Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbXKDUG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbXKDUG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 15:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbXKDUGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 15:06:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:16795 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXKDUGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 15:06:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JEffagHC+vkjqlI8MKlyQCDEA0eN9VajMChMK0Vkxqz7ORGcXNP+lreBrUrXF+Qe/tWADk0EHFw5paGxrOZb9KEeh5yuB7jZUPuUITwGRP+kV1Im0O1FxsJBGwlXy/Y9Pg5A3Lj3qdVwZECZn42D/bPmwB7LgcoMASRBRhfGNk8=
Message-ID: <1865922a0711041206m4a132200m19e33189137c901@mail.gmail.com>
Date: Sun, 4 Nov 2007 22:06:45 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Casey Schaufler" <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Cc: akpm@osdl.org, torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071103164303.GA26707@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/07, Ahmed S. Darwish <darwish.07@gmail.com> wrote:
>  static int smk_open_load(struct inode *inode, struct file *file)
>  {
> -       return seq_open(file, &load_seq_ops);
> +       if ((file->f_flags & O_ACCMODE) == O_RDONLY)
> +               return seq_open(file, &load_seq_ops);
> +
> +       if (down_interruptible(&smack_write_sem))
> +               return -ERESTARTSYS;
> +
> +       load_state = kzalloc(sizeof(struct smack_load_state), GFP_KERNEL);
> +       if (!load_state)
> +               return -ENOMEM;
> +
> +       return 0;
> +}

Is it right to do the kzalloc with the semaphore being held? Will the
lock be held forever If kzalloc failed and -ENOMEM was returned ?

Thanks,

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
