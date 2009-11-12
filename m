Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbZKLJyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbZKLJyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 04:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZKLJyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 04:54:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:12641 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZKLJyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 04:54:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UM63GAXMayosHCtztWXpf0uUJFn0t4No/jUUztEYrdJjKOjETZMAi2wemC3RNePVx2
         B8545tegrXdn1A1DDzgP4rywuX+M47OjgowCwxLpt+LpdfAv+EbrDtYpJeVHIwYOKnYz
         nOofSj2n/HkTkWfwtUANOCXQoc/hhqo8PzeH0=
MIME-Version: 1.0
In-Reply-To: <8FED46E8A9CA574792FC7AACAC38FE7714FE8307DB@PDSMSX501.ccr.corp.intel.com>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com>
	 <4AF4784C.5090800@zytor.com>
	 <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com>
	 <4AF7C66C.6000009@zytor.com> <20091109080830.GI453@elte.hu>
	 <8FED46E8A9CA574792FC7AACAC38FE7714FE830398@PDSMSX501.ccr.corp.intel.com>
	 <20091111203425.GA25401@lenovo> <4AFB3D31.6070901@zytor.com>
	 <aa79d98a0911112028nf3fc475r30aa8dc37936ea22@mail.gmail.com>
	 <8FED46E8A9CA574792FC7AACAC38FE7714FE8307DB@PDSMSX501.ccr.corp.intel.com>
Date: Thu, 12 Nov 2009 12:54:11 +0300
Message-ID: <aa79d98a0911120154uedca1caj6d971f1df01e8010@mail.gmail.com>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by fast 
	string.
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Ma, Ling" <ling.ma@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 7:49 AM, Ma, Ling <ling.ma@intel.com> wrote:
> Hi All
> The attachment is latest memcpy.c, please update by
> "cc -o memcpy memcpy.c -O2 -m64".
>
> Thanks
> Ling
>
>

Here is goes

                       	memcpy_orig	memcpy_new	memcpy_c
TPT: Len    0, alignment  0/ 0:	34482	31920	123564
TPT: Len    1, alignment  0/ 0:	31815	31710	123564
TPT: Len    2, alignment  0/ 0:	39606	31773	123522
TPT: Len    3, alignment  0/ 0:	175329	37212	123522
TPT: Len    4, alignment  0/ 0:	55440	42357	297129
TPT: Len    5, alignment  0/ 0:	63294	47607	296898
TPT: Len    6, alignment  0/ 0:	71148	52794	296856
TPT: Len    7, alignment  0/ 0:	79023	58044	296877
TPT: Len    8, alignment  0/ 0:	32403	32424	123564
TPT: Len    9, alignment  0/ 0:	31752	31815	123522
TPT: Len   10, alignment  0/ 0:	34482	34545	123522
TPT: Len   11, alignment  0/ 0:	42294	39732	123522
TPT: Len   12, alignment  0/ 0:	50211	42378	296856
TPT: Len   13, alignment  0/ 0:	58107	48279	329007
TPT: Len   14, alignment  0/ 0:	65898	53781	296877
TPT: Len   15, alignment  0/ 0:	73773	58065	296877
TPT: Len   16, alignment  0/ 0:	34482	37107	123522
TPT: Len   17, alignment  0/ 0:	31836	31815	123543
TPT: Len   18, alignment  0/ 0:	39627	37044	123522
TPT: Len   19, alignment  0/ 0:	47565	42294	123522
TPT: Len   20, alignment  0/ 0:	55566	47754	296898
TPT: Len   21, alignment  0/ 0:	63273	52773	296877
TPT: Len   22, alignment  0/ 0:	71148	58149	296856
TPT: Len   23, alignment  0/ 0:	79086	63273	296856
TPT: Len   24, alignment  0/ 0:	39816	45024	123522
TPT: Len   25, alignment  0/ 0:	37086	39753	123522
TPT: Len   26, alignment  0/ 0:	44877	44919	123522
TPT: Len   27, alignment  0/ 0:	52773	50253	123522
TPT: Len   28, alignment  0/ 0:	60690	55545	296898
TPT: Len   29, alignment  0/ 0:	68544	60690	296877
TPT: Len   30, alignment  0/ 0:	76398	65961	296877
TPT: Len   31, alignment  0/ 0:	84273	71211	296856
TPT: Len   32, alignment  0/ 0:	45045	52899	123522
TPT: Len   33, alignment  0/ 0:	42315	47628	123522
TPT: Len   34, alignment  0/ 0:	50127	52773	123522
TPT: Len   35, alignment  0/ 0:	58044	58107	123522
TPT: Len   36, alignment  0/ 0:	129612	63462	297129
TPT: Len   37, alignment  0/ 0:	257607	68733	902034
TPT: Len   38, alignment  0/ 0:	81879	73857	296919
TPT: Len   39, alignment  0/ 0:	89460	79023	296856
TPT: Len   40, alignment  0/ 0:	50253	60753	123543
TPT: Len   41, alignment  0/ 0:	47607	55545	123564
TPT: Len   42, alignment  0/ 0:	55356	60627	123522
TPT: Len   43, alignment  0/ 0:	63357	822843	123585
TPT: Len   44, alignment  0/ 0:	71337	71169	297087
TPT: Len   45, alignment  0/ 0:	79023	353388	297129
TPT: Len   46, alignment  0/ 0:	87024	81690	296856
TPT: Len   47, alignment  0/ 0:	94689	86940	296877
TPT: Len   48, alignment  0/ 0:	55482	68523	123522
TPT: Len   49, alignment  0/ 0:	52857	63336	123564
TPT: Len   50, alignment  0/ 0:	60690	68607	123522
TPT: Len   51, alignment  0/ 0:	68502	73731	123522
TPT: Len   52, alignment  0/ 0:	76419	79086	296856
TPT: Len   53, alignment  0/ 0:	84336	126147	296877
TPT: Len   54, alignment  0/ 0:	92190	89607	296877
TPT: Len   55, alignment  0/ 0:	100023	94668	296856
TPT: Len   56, alignment  0/ 0:	60690	76440	123522
TPT: Len   57, alignment  0/ 0:	58065	71211	123522
TPT: Len   58, alignment  0/ 0:	65877	76356	123522
TPT: Len   59, alignment  0/ 0:	73773	81606	196224
TPT: Len   60, alignment  0/ 0:	81732	86961	297129
TPT: Len   61, alignment  0/ 0:	89523	136689	296877
TPT: Len   62, alignment  0/ 0:	97377	97440	296877
TPT: Len   63, alignment  0/ 0:	105210	102564	296877
TPT: Len 1023, alignment  0/ 0:	457569	457107	719502
TPT: Len 1024, alignment  0/ 0:	422856	542535	575526
TPT: Len 2048, alignment  0/ 0:	819651	8217489	982779
