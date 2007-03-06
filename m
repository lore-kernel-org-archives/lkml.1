Return-Path: <linux-kernel-owner+w=401wt.eu-S933990AbXCFHxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933990AbXCFHxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933993AbXCFHxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:53:38 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:51112
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933990AbXCFHxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:53:37 -0500
Message-Id: <45ED2BDF.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Tue, 06 Mar 2007 07:52:47 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Virtualization Mailing List" <virtualization@lists.osdl.org>,
       <xen-devel@lists.xensource.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Andi Kleen" <ak@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/10] linux 2.6.18: COMPAT_VDSO
References: <45EC098D.76E4.0078.0@novell.com> <45EC787B.2020807@goop.org>
In-Reply-To: <45EC787B.2020807@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Ingo just raised this as an issue for paravirt_ops as well.  I don't
>quite follow what's going on there.   My understanding is that there are
>some old versions of glibc (which were unreleased CVS snapshots shipped
>by some vendors) which don't use the vdso's ELF header, but instead have
>their own canned one which built into the library itself.

Perhaps you meanwhile saw the similar question from Keir regarding this
(and my answer), but in short: plain glibc 2.3.2 (at least) supports AT_SYSINFO
but not AT_SYSINFO_HDR. In this scenario, moving the vDSO around is fine,
but glibc-internal (arguably broken) consistency checks prevent the vDSO from
being accepted when not using COMPAT_VDSO.

Jan
