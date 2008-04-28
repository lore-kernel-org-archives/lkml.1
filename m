Return-Path: <linux-kernel-owner+w=401wt.eu-S968570AbYD1XQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968570AbYD1XQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965597AbYD1XQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:16:28 -0400
Received: from rv-out-0708.google.com ([209.85.198.241]:19595 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965348AbYD1XQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:16:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=u+QJJLoPc3Qnnp9I4c9Gd/Rf0bx6iRQBHhZE2tlbrmdwGPfzXsYfg3MIQ9/rG8OrqaqItDfgLf6D9uK2eHX3qMn4e9ZRimtL+Eel9yU2y4PLe2yWeFVJvJsN3286C9zvt0DkOtmGpQQrkAC4UvHLnTGYbvrPltsTT1TqgJ7zrCE=
Message-ID: <86802c440804281616t6a62cb74h430b4ca598d101bc@mail.gmail.com>
Date: Mon, 28 Apr 2008 16:16:26 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>, balajirrao@gmail.com
In-Reply-To: <m17ieh4zuo.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <200801202256.48365.yinghai.lu@sun.com>
	 <20080122165125.GA17992@elte.hu>
	 <200801221623.20861.yinghai.lu@sun.com>
	 <20080426035614.a30afb17.akpm@linux-foundation.org>
	 <48132665.8050202@googlemail.com>
	 <86802c440804261805rc739f9as519213fecdc0cdff@mail.gmail.com>
	 <m17ieh4zuo.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 11:07 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>  > On Sat, Apr 26, 2008 at 5:56 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
>
>
> > another continuous MTRR mapping.
>  >
>  > several months ago, we were talking about modifying MTRR. but Eric
>  > said that is not safe because acpi and smi...
>
>  I think it was Andi who spotted that originally, and yes I do think it
>  is a pretty horrific failure mode.  Reprogramming the MTRRs requires
>  full knowledge of the hardware and what is going on that we don't
>  always have.  PAT support has just been merged, and using that only
>  requires knowledge about the region whose attributes we intend to change.
>
>  So lets concentrate on PAT to solve contiguous MTRR region problems.
>
>  We can upgrade UC to WC with pat.  As well as demote WB to UC or WC.
>  So for those regions we know about we should be in good shape.
>
>  In a slightly related vein.  Trimming the memory we consider usable by
>  looking at MTRRs and if a region is not WB not considering it RAM
>  sounds like a very reasonable work around for one class of BIOS bugs.

yeah, i will look at to loop the ram region array instead of checking
highest_pfn only...


YH
