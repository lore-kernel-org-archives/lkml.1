Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYJDHUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYJDHUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 03:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYJDHUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 03:20:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:36501 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYJDHUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 03:20:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=r6UgodmUXyBWHXxwvN+ScscYXkBE0Zw3mleZ6d44avtz81vtHafeGnUrNDaTWSlLMP
         i7VC2aIeoUsFg/WeQ2HyDFiIcmoTr3AZtZMiik//pPDVylkMeFzU3cGf47+T665uqHFF
         CsrEGZ2PPhvV81P4RBivSaBCDnBihj4pLtMco=
Message-ID: <7c86c4470810040020u126dfc1eg7d6db13078239e7e@mail.gmail.com>
Date: Sat, 4 Oct 2008 09:20:00 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "David Gibson" <david@gibson.dropbear.id.au>, eranian@gmail.com,
       linux-kernel@vger.kernel.org,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perfmon3 interface overview
In-Reply-To: <20081004060506.GO30184@yookeroo.seuss>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com>
	 <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com>
	 <20081003061713.GL3002@yookeroo.seuss>
	 <7c86c4470810030354x6984372akfe18761da7504a0c@mail.gmail.com>
	 <7c86c4470810030358m1a0fdcc5i5512a1c2a6696457@mail.gmail.com>
	 <7c86c4470810030412l34d3dc13mef10c9320884d635@mail.gmail.com>
	 <20081004060506.GO30184@yookeroo.seuss>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Sat, Oct 4, 2008 at 8:05 AM, David Gibson
<david@gibson.dropbear.id.au> wrote:
>>
>> If we wanted to go even further, we could combine start/stop, attach/detach
>> into  a single syscall:
>
> Well, you could.  But the attach/detach take a parameter which
> start/stop don't, making it a less obvious merge to make.
>
Unless you make the 3rd argument optional and hide this in a
user library. This is how this is handled for pfm_create_session()
for instance. The library would define this as follows:

   int pfm_control_session(int fd, int flags, ...);

Based upon flags, it would use va_arg() to get to the 3rd argument and
pass it to the syscall which implements the version below. A dummy value
would be passed with the flags is not equal to PFM_CTFL_ATTACH.

>>    int pfm_control_session(int fd, int flags, int target);
>>    With flags:
>>        PFM_CTFL_START  : start monitoring
>>        PFM_CTFL_STOP    : stop monitoring
>>        PFM_CTFL_RESTART: resume after overflow notification
>>
>>        PFM_CTFL_ATTACH: attach to thread or cpu designated by 'target'
>>        PFM_CTFL_DETACH: detach session
>>
