Return-Path: <linux-kernel-owner+w=401wt.eu-S1764262AbZAOR4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262AbZAOR4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761321AbZAORzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:55:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45258 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761291AbZAORzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:55:52 -0500
Message-ID: <496F788B.3090104@zytor.com>
Date: Thu, 15 Jan 2009 09:55:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "harvey.harrison@gmail.com" <harvey.harrison@gmail.com>,
       "sam@ravnborg.org" <sam@ravnborg.org>,
       "jaswinderrajput@gmail.com" <jaswinderrajput@gmail.com>
Subject: Re: [patch 3/5] x86: headers cleanup - ptrace-abi.h
References: <20090114203745.285473388@gmail.com>> <496e4e23.0c07560a.5e4e.529c@mx.google.com> <496E6585.8050505@zytor.com> <928CFBE8E7CB0040959E56B4EA41A77E0CD9CD33@irsmsx504.ger.corp.intel.com> <20090115084110.GB9032@localhost> <496F69C8.2040103@zytor.com> <20090115173324.GC9032@localhost>
In-Reply-To: <20090115173324.GC9032@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Let me explain more detailed what I've meant with my prev message.
> Markus said that ptrace_bts_config is supposed to be visible in userspace,
> right? So I've a program which is built under kernel with
> CONFIG_X86_PTRACE_BTS turned on. Then I rebuild my kernel with
> CONFIG_X86_PTRACE_BTS turned off. Then I decide to recompile
> my program for some reason _and_ compilation shouldn't fail
> because of lack of ptrace_bts_config struct. So for userspace
> kernel configuration does matter if it touches data being referenced
> from user-side. BUT all I said is valid (at least I hop so) if _only_
> ptrace_bts_config is supposed to be visible to user-space programs.
> 

CONFIG_* is not visible to userspace.  Furthermore, there is (almost) no
point in putting a structure definition under #ifdef unless it uses data
types that somehow depend on the configuration (and those data
structures would be fundamentally ineligible to be exported to
userspace!!) -- if the feature isn't configured the structure definition
just doesn't get used.

> | 
> | This would be yet another good reason why having them be always defined
> | and 0/1 instead would be such an improvement, but we're not there.
> | 
> 
> oh, that reminds me autoconf horror :) I don't know if it possible
> but we could have some common/base file with all CONFIG_ set to 0/1
> which any header being exported to userspace should include, or
> we could modify unifdef to process headers in fashion: scan the header,
> insert CONFIG_'s refered in the header with value 0/1 at top of the
> header. Not sure if it worth it (too many files are to be touched).
> 

No, no, no, no, no.

We're not exporting CONFIG_* to userspace.

The point was that if we were using #if instead of #ifdef, then -Wundef
could be used to complain instead of silently ignoring sections.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

