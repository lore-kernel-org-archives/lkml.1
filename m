Return-Path: <linux-kernel-owner+w=401wt.eu-S1763036AbXGSUw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763036AbXGSUw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755808AbXGSUwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:52:50 -0400
Received: from gw.goop.org ([64.81.55.164]:52818 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbXGSUwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:52:49 -0400
Message-ID: <469FCEE7.8060900@goop.org>
Date: Thu, 19 Jul 2007 13:51:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, Zachary Amsden <zach@vmware.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patches] new text patching for review
References: <200707191105.44056.ak@suse.de> <p73d4yow0ys.fsf@bingen.suse.de> <469FC9D4.5070604@goop.org> <200707192246.58047.ak@suse.de>
In-Reply-To: <200707192246.58047.ak@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Normally there are not that many NMIs or MCEs at boot, but it would
> be still good to avoid the very rare crash by auditing the code first
> [better than try to debug it on some production system later]
>   

Auditing it for what?  If we want to make patching safe against NMI/MCE,
I guess we need to make sure those handlers don't use any pvops, but
that seems unreasonable if they want to poke at MSRs and so on.

> In theory yes, in practice there can be errata of course. There tend 
> to be a couple with self modifying code, especially cross modifying
> (from another CPU) -- but you don't do that.
>   

No, but the pv-ops patching code should have no requirement for
atomicity at all; we shouldn't be trying to patch a live instruction stream.

    J
