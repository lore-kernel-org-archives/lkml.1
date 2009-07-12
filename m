Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZGLWDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZGLWDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZGLWC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:02:57 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57621 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZGLWC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Q6QG2vxq0ZlHZOVJ57FYkna8ebDgtyl4C+54NHmY9w8J7eTB49czE3xSRHuFnnk0IR
         4RZIfuvVL1uXpDR8jwLwbUIypiA44M74UoXEg6PoQuBtb4GXZWDu2Iu82q7Q7vvFd5cA
         4bWOQwYYEp4wVB5PswB4YWXiS3tKWFZMffeCQ=
MIME-Version: 1.0
In-Reply-To: <4A5A46ED.7010907@gmail.com>
References: <1247410030.1095.1.camel@localhost> <loom.20090712T172408-520@post.gmane.org> 
	<4A5A46ED.7010907@gmail.com>
From: Parag Warudkar <parag.warudkar@gmail.com>
Date: Sun, 12 Jul 2009 17:54:28 -0400
Message-ID: <82e4877d0907121454l6d19f739t26d37b8f275250ad@mail.gmail.com>
Subject: Re: 2.6.31-rc2: BUG: unable to handle kernel NULL pointer dereference
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, thomas@m3y3r.de, sds@tycho.nsa.gov,
       jmorris@namei.org, eparis@parisplace.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 4:26 PM, Jiri Slaby<jirislaby@gmail.com> wrote:
> On 07/12/2009 07:30 PM, Parag Warudkar wrote:
>> static void selinux_write_opts(struct seq_file *m,
>> 1012                                struct security_mnt_opts *opts)
>> 1013 {
>> 1014         int i;
>> 1015         char *prefix;
>> 1016
>> 1017         for (i = 0; i < opts->num_mnt_opts; i++) {
>> 1018                 char *has_comma;
>> 1019
>> 1020                 if (opts->mnt_opts[i])
>> 1021                         has_comma = strchr(opts->mnt_opts[i], ',');
>>                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
>> And that is a NULL pointer dereference - but we just checked for
>> opts->mnt_opts[i] for not NULL.
>
> Note, that there is not a NULL dereference. It dereferences 0x40 which
> came in as %rdi. Looks like somebody assigned garbage in there.

Ah right - anything < PAGE_SIZE is "NULL" dereference to the kernel.

Thanks
