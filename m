Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbYHYWjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbYHYWjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 18:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYHYWjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 18:39:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:38601 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYHYWjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 18:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=O1K30Uo826iYt4dVvxh3UAb7Zb06frgBgRuLFOg6E+TYOROIdGkqp3BpnM3BNmAc3X
         08TVr5MzmuMBwnDWnaXxHBPXdU8+sTDxGza0MJj8Gy5WnEWitWUtOxiL3P4jorSkg/Ps
         Bvhqprq77gCCdQx88LwkzSe24y1+c9s8aUqlQ=
Message-ID: <12c511ca0808251539w6f00a216s86a09a532c553a34@mail.gmail.com>
Date: Mon, 25 Aug 2008 15:39:13 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: PATCH] debug: add notifier chain debugging
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20080815152938.4bc9d48c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080815152938.4bc9d48c@infradead.org>
X-Google-Sender-Auth: 0c6534fa138c0c20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 3:29 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> +       if (!kernel_text_address((unsigned long)n->notifier_call)) {
> +               WARN(1, "Invalid notifier registered!");
> +               return 0;
> +       }

This breaks on ia64 (and pa-risc I think) where function pointers don't point
directly at the code, they point to a {code,data} structure which is itself
located in data space, not text space.

-Tony
