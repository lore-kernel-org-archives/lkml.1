Return-Path: <linux-kernel-owner+w=401wt.eu-S1761901AbZAORde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761901AbZAORde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbZAORd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:33:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:15601 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZAORdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TrSCuJ/3KFgKrgBzOMyMZsLDhbUH8Y6//OE1ac7EEwviTfe5SgmNZ3P4fpJyDrxU0e
         94tr9gozKSKVPJTu63RsXAEAnVQrsjjj6NqPpnDDCKx32nGwoPucCfbnynvf69ZYr35z
         3ytQP3FZs+TmD4c9FvYH9DXHSn72K89Lnk0Yk=
Date: Thu, 15 Jan 2009 20:33:24 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "harvey.harrison@gmail.com" <harvey.harrison@gmail.com>,
       "sam@ravnborg.org" <sam@ravnborg.org>,
       "jaswinderrajput@gmail.com" <jaswinderrajput@gmail.com>
Subject: Re: [patch 3/5] x86: headers cleanup - ptrace-abi.h
Message-ID: <20090115173324.GC9032@localhost>
References: <20090114203745.285473388@gmail.com>> <496e4e23.0c07560a.5e4e.529c@mx.google.com> <496E6585.8050505@zytor.com> <928CFBE8E7CB0040959E56B4EA41A77E0CD9CD33@irsmsx504.ger.corp.intel.com> <20090115084110.GB9032@localhost> <496F69C8.2040103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496F69C8.2040103@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Thu, Jan 15, 2009 at 08:52:24AM -0800]
| Cyrill Gorcunov wrote:
| > 
| > Hi Markus,
| > 
| > since it's supposed to be visible by userspace then we
| > should just remove this CONFIG_X86_PTRACE_BTS so if userspace
| > app has a reference to ptrace_bts_config but kernel in turn has
| > this feature turned off -- the uerspace app shouldn't fail
| > while being compiling.
| > 
| 
| Well, for userspace, the kernel configuration doesn't matter: the
| CONFIG_* macros *never* exist.

Let me explain more detailed what I've meant with my prev message.
Markus said that ptrace_bts_config is supposed to be visible in userspace,
right? So I've a program which is built under kernel with
CONFIG_X86_PTRACE_BTS turned on. Then I rebuild my kernel with
CONFIG_X86_PTRACE_BTS turned off. Then I decide to recompile
my program for some reason _and_ compilation shouldn't fail
because of lack of ptrace_bts_config struct. So for userspace
kernel configuration does matter if it touches data being referenced
from user-side. BUT all I said is valid (at least I hop so) if _only_
ptrace_bts_config is supposed to be visible to user-space programs.

| 
| This would be yet another good reason why having them be always defined
| and 0/1 instead would be such an improvement, but we're not there.
| 

oh, that reminds me autoconf horror :) I don't know if it possible
but we could have some common/base file with all CONFIG_ set to 0/1
which any header being exported to userspace should include, or
we could modify unifdef to process headers in fashion: scan the header,
insert CONFIG_'s refered in the header with value 0/1 at top of the
header. Not sure if it worth it (too many files are to be touched).

| 	-hpa
| 
| -- 
| H. Peter Anvin, Intel Open Source Technology Center
| I work for Intel.  I don't speak on their behalf.
| 

		- Cyrill -
