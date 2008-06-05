Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYFEKyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYFEKyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 06:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754928AbYFEKxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 06:53:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:27835 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbYFEKxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 06:53:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=rF0lkcOj1H9WbymU8tWBjKJpvo/53yivRKTrsuBSvXBkMJv+50aWIBTNTDfLY1k7Ir
         8JK87d/QcMJ/iKz4K+Jwp3K2l8n4csI4ndESa5vts4GXibY9CcLMYC144oRaadSiEZQ8
         072//qhhlJdxiF5lLM7TcaaXl+uh7+lKsuj7k=
Message-ID: <2f11576a0806050353y1c68c24co1584688eb348c690@mail.gmail.com>
Date: Thu, 5 Jun 2008 19:53:50 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] introduce task cgroup (#task restrictioon for prevent fork bomb by cgroup)
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       "Paul Menage" <menage@google.com>
In-Reply-To: <48477DFB.5010906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48477DFB.5010906@cn.fujitsu.com>
X-Google-Sender-Auth: ca248fee977424e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You are not handling task migration between groups, i.e.:
>        # echo $$ > /cgroup/1/tasks
>        # echo $$ > /cgroup/2/tasks

Oh, nice point out.
Thanks!


> Maybe you need to add this in cgroup_init_subsys():
>
> -       need_forkexit_callback |= ss->fork || ss->exit;
> +       need_forkexit_callback |= ss->fork || ss->exit || ss->can_fork;
>
> and then we can do:
>
> if (need_forkexit_callback) {
>        for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {

good idea :)
I'll fix it at next post.
