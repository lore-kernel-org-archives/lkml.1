Return-Path: <linux-kernel-owner+w=401wt.eu-S1762739AbYG3POT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739AbYG3POT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbYG3POG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:14:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:10170 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYG3POE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:14:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fHOywnyRLl4UOjvYXKSLQr5RVEuOmj2PdnZ8fXc/xvydT7joGJoRlHQaShqkDYH+ED
         G+74K3unf7zsulK2M+LxCBJ4rVSABhLi8ZZm52Ovg82ISU/JTCgiFv27jrHqWHmjyMq3
         gQI3sd06YwJ3EU8DEFDeJWeem+n8QjuuyDacg=
Message-ID: <170fa0d20807300814o7741859eu8ad5d5b3b95e401c@mail.gmail.com>
Date: Wed, 30 Jul 2008 11:14:02 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Hidehiro Kawai" <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH 1/2] ext3: add an option to control error handling on file data
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, jack@suse.cz,
       jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu, tglx@linutronix.de,
       yumiko.sugita.yf@hitachi.com, satoshi.oshima.fk@hitachi.com
In-Reply-To: <488FD756.9060106@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488FD756.9060106@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 10:52 PM, Hidehiro Kawai
<hidehiro.kawai.ez@hitachi.com> wrote:
> If the journal doesn't abort when it gets an IO error in file data
> blocks, the file data corruption will spread silently.  Because
> most of applications and commands do buffered writes without fsync(),
> they don't notice the IO error.  It's scary for mission critical
> systems.  On the other hand, if the journal aborts whenever it gets
> an IO error in file data blocks, the system will easily become
> inoperable.  So this patch introduces a filesystem option to
> determine whether it aborts the journal or just call printk() when
> it gets an IO error in file data.
>
> If you mount a ext3 fs with data_err=abort option, it aborts on file
> data write error.  If you mount it with data_err=ignore, it doesn't
> abort, just call printk().  data_err=abort is default, because
> people have used this error handling policy for three years.

Hidehiro,

Thanks for making this configurable!

But given how surprised many of us were when we found out that
jbd/ext3 has been aborting on file data blocks isn't this our chance
to correct that long-standing oversight?  Shouldn't the default be
data_err=ignore?  Or would changing this behavior cause more harm than
good?

I don't feel strongly either way, having the "data_err" option makes
this issue moot for me, but I figured I'd raise the question (in the
interest of review).

Mike
