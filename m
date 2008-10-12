Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYJLNcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYJLNcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYJLNcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:32:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:10913 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYJLNcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PdffN0AbvoCjzBEN1MAXPN5Yj9aPPmKcPd4IXwper+kg8E1Wq6TJuJCjqXdd7BcXAm
         n9Tw2sizrzkpd/1WFzodl28aFi509qcD2VILuf1VGAUwC6V5Q5WaDO8dyv0Xz7TYrjIz
         92yR/sHsrC1jR4qH/OJ/Sn+hLY7SEjJ1Z+7AQ=
Message-ID: <c62985530810120631g3e464503i8958d160e6b1aa3e@mail.gmail.com>
Date: Sun, 12 Oct 2008 15:31:59 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "=?ISO-8859-1?Q?T=F6r=F6k_Edwin?=" <edwintorok@gmail.com>
Subject: Re: [PATCH 1/4] Add support for userspace stacktraces in tracing/iter_ctrl
Cc: mingo@elte.hu, srostedt@redhat.com, a.p.zijlstra@chello.nl,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
In-Reply-To: <1223817124-27239-3-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>
	 <1223817124-27239-3-git-send-email-edwintorok@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/12 Török Edwin <edwintorok@gmail.com>:
> +static int copy_stack_frame(const void __user *fp, struct stack_frame *frame)
> +{
> +       int ret;
> +
> +       if (!access_ok(VERIFY_READ, fp, sizeof(*frame)))
> +               return 0;
> +
> +       ret = 1;
> +       pagefault_disable();
> +       if (__copy_from_user_inatomic(frame, fp, sizeof(*frame)))
> +               ret = 0;
> +       pagefault_enable();
> +
> +       return ret;
> +}
> +

Hello Török,

I don't understand why you are using this pagefault disabling and
atomic copy here.
Wouldn't a simple copy_from_user actually take of this? You don't seem
to be in atomic
context.
