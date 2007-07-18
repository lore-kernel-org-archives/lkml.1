Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbXGRPx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbXGRPx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbXGRPxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:53:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:18051 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbXGRPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:53:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DbmDgUu6juWlkj6CZea1QzoiW4rxY8ITe6Yg855mshGuKlzeZB0CfaUyvQRr06qveYmJEeNByzVI2dyqlyge8B5Je7hYkTGqMft2ekGzHqkKSW3BX0MywW9EU0DoZq80tE99pWFxw3BIsiE9sonOCMinWN4+iRI/Tg7+77I/hAg=
Message-ID: <469E3786.4090409@gmail.com>
Date: Thu, 19 Jul 2007 00:53:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure
 path
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>	 <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com>	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>	 <20070718071445.GI23568@htj.dyndns.org>	 <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>	 <469E2A68.6010307@gmail.com>	 <a781481a0707180816r478d2512v953036a1e4145a72@mail.gmail.com> <a781481a0707180830g44cdd38etb4a540afce218065@mail.gmail.com>
In-Reply-To: <a781481a0707180830g44cdd38etb4a540afce218065@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
>> sysfs_find_dirent() -- to check for -EEXIST -- should be called
>> *before* we create the new dentry for the to-be-created symlink
>> in the first place. [ It's weird to grab a reference on the target
>> for ourselves (and in fact even allocate the new dirent for the
>> to-be-created symlink) and /then/ check for erroneous usage,
>> and then go about undoing all that we should never have done
>> at all. ] So this test could, and should, be made earlier, IMHO.
> 
> A trivial nit:
> 
> The cleanup ignores the return of sysfs_addrm_finish() -- functions
> such as those could and should be void-returning. It doesn't even
> need to return an int for success / failure ... I went over it's code,
> and it's obvious that the function just never fails!
> 
> Returning the count of objects actually added / removed is quite
> redundant too, because we return "actx->cnt" unconditionally
> from inside it, and the caller can know that anyway, without
> even calling it. Also, note that nowhere in the present code is
> the return of that function ever being used in that sense (i.e. as
> a "count") anyway ...
> 
> So: best to just make it void-returning. That's what it is.

Oh well, the function was made that way because that made the conversion
easier when add/rm paths were consolidated using sysfs_addrm_cxt and
friends.  So, if you see the detail as a problem, please submit a patch.
 I dunno whether I would agree with the patch or not without seeing one.

Thanks.

-- 
tejun
