Return-Path: <linux-kernel-owner+w=401wt.eu-S932702AbYBHQPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbYBHQPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 11:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbYBHQO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:14:57 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:65218 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbYBHQO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:14:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gvLSjk72KeTmSzqXDOOMbE0Dd7FAX7Fdvqk2o12s8sJAzJcn8iUc/vzGQV2KwG8b38GWtqODSkH29kcY/nR1tN2I/iKQdBVfAGFpon/hZYJ/PaI0Oe79v7NNsOQO6m/63ScfaFf0Sgb5gSRs/eC8TiyIjVfOO5sf+8CDW2uZc5M=
Message-ID: <15577be70802080814j1bb21b30r6f8a82e35aa8dc07@mail.gmail.com>
Date: Fri, 8 Feb 2008 17:14:50 +0100
From: "Abel Bernabeu" <abelbg@m2grp.com>
Reply-To: abelbg@m2grp.com
To: linux-kernel@vger.kernel.org
Subject: Re: Elf loader crash while zero-filling .bss
In-Reply-To: <15577be70801310738x3afcc393k6cf8f7151677528c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15577be70801300309k4eb84047peb4bffd4b41cbaa7@mail.gmail.com>
	 <15577be70801310738x3afcc393k6cf8f7151677528c@mail.gmail.com>
X-Google-Sender-Auth: 3992e702feb59612
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/31, Abel Bernabeu <abelbg@m2grp.com>:
> 2008/1/30, Abel Bernabeu <abelbg@m2grp.com>:
>
> > Now I am trying to execute some bigger C applications: in instance
> > BusyBox. I've chosen the buildroot package in order to produce a small
> > "distro".
> >
> > Then I've tried to boot the system using init=/bin/sh but I am getting
> > a crash while loading this non-toy binary.

Hi guys,

Excuse me for posting even another message about the same crash (I am
responding myself anyway :). It is my crash and I will find why
happens! :D

I've found THE COMMON DENOMINATOR present in all the binaries that get
my kernel crash.

The offset of some sections fall in the middle of the .bss section. In
instance, look at the sections 12 (.comment) and 13 (.ARM.atributes).
Both sections are overlapping with 11 (.bss):

[11] .bss                 NOBITS       0001143c 00143c 000048  0 WA     0   0  4
[12] .comment             PROGBITS     00000000 00143c 000094  0        0   0  1
[13] .ARM.attributes      SHT_LOPROC+3 00000000 0014d0 000010  0        0   0  1
[14] .shstrtab            STRTAB       00000000 0014e0 00007b  0        0   0  1
[15] .symtab              SYMTAB       00000000 001804 000c70 16       16  92  4
[16] .strtab              STRTAB       00000000 002474 000840  0        0   0  1

Is this fact meaningful??

I don't think this .elf file is correct and you can blame my
cross-compiler building skills... but the kernel should be friendly
enough to tell me about the problem instead of crashing :)

Any ideas?

Yours, Abel.
