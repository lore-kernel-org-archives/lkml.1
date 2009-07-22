Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZGVRZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZGVRZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZGVRZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:25:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:48082 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZGVRZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kzHaw3CT7AUxLYeAdvEUc7jQtBspGCH+vMnwI4+b0mz7xtCVcrfEkwBqwihqR/PG87
         RHDpfRHQx7sWHVrrISz6uz8fanPmt+fwlrTTCbdd4dncLArvzl64htOnYGi7xZLhtrRr
         JYTh4reVw5Ql1XLgmVLtwtGh4paJwyN2LfBB0=
Date: Wed, 22 Jul 2009 21:25:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oren Laadan <orenl@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [RFC v17][PATCH 52/60] c/r: support semaphore sysv-ipc
Message-ID: <20090722172502.GA15805@lenovo>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-53-git-send-email-orenl@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248256822-23416-53-git-send-email-orenl@librato.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Oren Laadan - Wed, Jul 22, 2009 at 06:00:14AM -0400]
...
| +static struct sem *restore_sem_array(struct ckpt_ctx *ctx, int nsems)
| +{
| +	struct sem *sma;
| +	int i, ret;
| +
| +	sma = kmalloc(nsems * sizeof(*sma), GFP_KERNEL);

Forgot to

	if (!sma)
		return -ENOMEM;

right?

| +	ret = _ckpt_read_buffer(ctx, sma, nsems * sizeof(*sma));
| +	if (ret < 0)
| +		goto out;
| +
| +	/* validate sem array contents */
| +	for (i = 0; i < nsems; i++) {
| +		if (sma[i].semval < 0 || sma[i].sempid < 0) {
| +			ret = -EINVAL;
| +			break;
| +		}
| +	}
| + out:
| +	if (ret < 0) {
| +		kfree(sma);
| +		sma = ERR_PTR(ret);
| +	}
| +	return sma;
| +}
...

	-- Cyrill
