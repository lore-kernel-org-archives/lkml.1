Return-Path: <linux-kernel-owner+w=401wt.eu-S1751875AbXLYXkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbXLYXkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbXLYXkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:40:37 -0500
Received: from ozlabs.org ([203.10.76.45]:36671 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbXLYXkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:40:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 04/16] per-cpu run guest
Date: Wed, 26 Dec 2007 10:38:45 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest@ozlabs.org, glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rostedt@goodmis.org
References: <11981576363806-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com>
In-Reply-To: <11981576581695-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712261038.46376.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 00:33:44 Glauber de Oliveira Costa wrote:
> @@ -55,11 +55,15 @@ static int user_send_irq(struct lguest *lg, const
> unsigned long __user *input) static ssize_t read(struct file *file, char
> __user *user, size_t size,loff_t*o) {
>  	struct lguest *lg = file->private_data;
> +	struct lguest_vcpu *vcpu = NULL;
> +	unsigned int vcpu_id = *o;
>
>  	/* You must write LHREQ_INITIALIZE first! */
>  	if (!lg)
>  		return -EINVAL;
>
> +	vcpu = &lg->vcpus[vcpu_id];
> +

Better do a bounds check here!

Cheers,
Rusty.
