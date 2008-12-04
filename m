Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYLDS64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYLDS64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 13:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYLDS6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 13:58:47 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:41686 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYLDS6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 13:58:46 -0500
Date: Thu, 4 Dec 2008 10:58:30 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>, oleg@redhat.com,
       ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, xemul@openvz.org
Subject: Re: [RFC][PATCH 4/5] Protect cinit from fatal signals
Message-ID: <20081204185830.GC23906@us.ibm.com>
References: <20081126034242.GA23120@us.ibm.com> <20081126034634.GD23238@us.ibm.com> <20081127010753.GB13545@wavehammer.waldi.eu.org> <20081201202112.GC12493@us.ibm.com> <20081202120606.GD1132@wavehammer.waldi.eu.org> <20081202205130.GB20077@us.ibm.com> <20081204125213.GB31061@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204125213.GB31061@wavehammer.waldi.eu.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastian Blank [bastian@waldi.eu.org] wrote:
| > Secondly, a poorly written container-inits can take the entire container down,
| > So we expect that container-inits to handle/ignore all signals rather than
| > SIG_DFL them. Current global inits do that today and container-inits should
| > too. It does not look like an unreasonable requirement.
| 
| So you intend to workaround tools which are used as container-init but
| does not qualify for this work. Why?

Sorry, but I don't understand the "does not qualify for this work" part.
Can you please rephrase ?

| 
| > So the basic requirements are:
| > 
| > 	- container-init receives/processes all signals from ancestor namespace.
| > 	- container-init ignores fatal signals from own namespace.
| > 
| > We are simplifying the first to say that:
| > 
| > 	- parent-ns must have a way to terminate container-init
| > 	- cinit will ignore SIG_DFL signals that may terminate cinit even if
| > 	  they come from parent ns
| 
| This is no simplification. This are more constraints.

Yes cinit ignoring SIG_DFL exit signals from parent-ns is a constraint.
So if we run say sshd as container-init, we can't use SIGINT to
terminate it, but need SIGKILL 

The question is whether this constraint makes any serious/real cinits
unusable ?

The behavior at present is that cinits can be terminated from within
and cinits cannot do anything in user-space. With this incremental
step at least user space has an option of ignoring such signals.

Sukadev
