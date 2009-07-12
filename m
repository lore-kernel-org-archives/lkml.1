Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZGLU0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZGLU0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZGLU00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:26:26 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:45923 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZGLU00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:26:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=j3ZgfRDMtYzfUMthveueabGII1g7el7X+Q5qIPpIN9LUtVMlwDlxrmZADMfM913ckT
         bX7psluDrZsRzFXRzZovqnufg8ZtX+Jkur1ot8db3R6biyrqRV7JvpeiNWxXKiXaYflI
         KhCIwOd3AqiELO5NEKHdVbPzblx4XbxQmQxik=
Message-ID: <4A5A46ED.7010907@gmail.com>
Date: Sun, 12 Jul 2009 22:26:21 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Parag Warudkar <parag.warudkar@gmail.com>
CC: linux-kernel@vger.kernel.org, thomas@m3y3r.de, sds@tycho.nsa.gov,
       jmorris@namei.org, eparis@parisplace.org
Subject: Re: 2.6.31-rc2: BUG: unable to handle kernel NULL pointer dereference
References: <1247410030.1095.1.camel@localhost> <loom.20090712T172408-520@post.gmane.org>
In-Reply-To: <loom.20090712T172408-520@post.gmane.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2009 07:30 PM, Parag Warudkar wrote:
> static void selinux_write_opts(struct seq_file *m,
> 1012                                struct security_mnt_opts *opts)
> 1013 {
> 1014         int i;
> 1015         char *prefix;
> 1016
> 1017         for (i = 0; i < opts->num_mnt_opts; i++) {
> 1018                 char *has_comma;
> 1019
> 1020                 if (opts->mnt_opts[i])
> 1021                         has_comma = strchr(opts->mnt_opts[i], ',');
>                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
> And that is a NULL pointer dereference - but we just checked for
> opts->mnt_opts[i] for not NULL. 

Note, that there is not a NULL dereference. It dereferences 0x40 which
came in as %rdi. Looks like somebody assigned garbage in there.

Or a single bit mem error. Is memtest OK with this machine?

What warning tainted the kernel before this oops is still interesting...
