Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZJPHHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZJPHHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 03:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZJPHHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 03:07:09 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:58040 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZJPHHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 03:07:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o6zS6uEDV9vr+gekftuNXmpIS4NBeBvh9ELvIV6QDnkKh+YCVQJjyoXYCyMpqJ1InL
         9VES5o+KUTWNJX8VG0Znk+N386TprzRnPuWMOZWqGDzGRebrRImHCj1vdZVCMFppW3sg
         dDoz2RENAfzmrEgmSdBeFvT/F+ZqTHPZjTZ70=
MIME-Version: 1.0
In-Reply-To: <18475.1255529305@redhat.com>
References: <1255516134-4838-1-git-send-email-graff.yang@gmail.com> 
	<18475.1255529305@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 16 Oct 2009 03:06:11 -0400
Message-ID: <8bd0f97a0910160006y3e0479b1o390579a0cd469533@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] mm/nommu.c: Fix improperly call of 
	security API in mmap
To: David Howells <dhowells@redhat.com>
Cc: graff.yang@gmail.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org, gyang@blackfin.uclinux.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 10:08, David Howells wrote:
> <graff.yang@gmail.com> wrote:
>> The original code calling security_file_mmap() use user's hint address
>> as it's 5th argument(addr). This is improper, as the hint address may be
>> NULL.
>> In this case, the security_file_mmap() may incorrectly return -EPERM.
>>
>> This patch moved the calling of security_file_mmap() out of
>> validate_mmap_request() to do_mmap_pgoff(), and call this
>> security API with the address that attempting to mmap.
>
> I think this is the wrong approach.  Firstly, the hint is cleared in NOMMU
> mode, and secondly, I think that the check against the minimum LSM address is
> pointless in NOMMU mode too.
>
> So I think the attached patch is a better approach.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
