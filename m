Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYLDMw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYLDMw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYLDMwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:52:16 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:37297 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbYLDMwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:52:15 -0500
Date: Thu, 4 Dec 2008 13:52:13 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: oleg@redhat.com, ebiederm@xmission.com, roland@redhat.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       xemul@openvz.org
Subject: Re: [RFC][PATCH 4/5] Protect cinit from fatal signals
Message-ID: <20081204125213.GB31061@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, oleg@redhat.com,
	ebiederm@xmission.com, roland@redhat.com, containers@lists.osdl.org,
	linux-kernel@vger.kernel.org, xemul@openvz.org
References: <20081126034242.GA23120@us.ibm.com> <20081126034634.GD23238@us.ibm.com> <20081127010753.GB13545@wavehammer.waldi.eu.org> <20081201202112.GC12493@us.ibm.com> <20081202120606.GD1132@wavehammer.waldi.eu.org> <20081202205130.GB20077@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081202205130.GB20077@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 12:51:30PM -0800, Sukadev Bhattiprolu wrote:
> Bastian Blank [bastian@waldi.eu.org] wrote:
> | No. They have are not special from the outside namespace.
> I agree that they should not be. But they are special today in at least one
> respect - terminating a container-init will terminate all processes in the
> container even those that are in unrelated process groups.

This is part of the definition.

> Secondly, a poorly written container-inits can take the entire container down,
> So we expect that container-inits to handle/ignore all signals rather than
> SIG_DFL them. Current global inits do that today and container-inits should
> too. It does not look like an unreasonable requirement.

So you intend to workaround tools which are used as container-init but
does not qualify for this work. Why?

> So the basic requirements are:
> 
> 	- container-init receives/processes all signals from ancestor namespace.
> 	- container-init ignores fatal signals from own namespace.
> 
> We are simplifying the first to say that:
> 
> 	- parent-ns must have a way to terminate container-init
> 	- cinit will ignore SIG_DFL signals that may terminate cinit even if
> 	  they come from parent ns

This is no simplification. This are more constraints.

Bastian

-- 
No one can guarantee the actions of another.
		-- Spock, "Day of the Dove", stardate unknown
