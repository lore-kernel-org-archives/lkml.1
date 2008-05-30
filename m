Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbYE3XLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbYE3XLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbYE3XKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:10:51 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60629 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755878AbYE3XKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:10:50 -0400
To: darwish.07@gmail.com, casey@schaufler-ca.com, paul.moore@hp.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH BUGFIX -v2 -rc4] Smack: Respect 'unlabeled' netlabel mode
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20080530233603.GA2994@ubuntu>
	<20080530235751.GA6888@ubuntu>
In-Reply-To: <20080530235751.GA6888@ubuntu>
Message-Id: <200805310810.FJG69298.HtLQSVFOFMOJOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 31 May 2008 08:10:45 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Ahmed S. Darwish wrote:
>  	default:
> +		mutex_lock(&smack_ambient_lock);
> +		nlsp->domain = kstrdup(smack_net_ambient, GFP_ATOMIC);
> +		mutex_unlock(&smack_ambient_lock);
> +
> +		nlsp->flags = NETLBL_SECATTR_DOMAIN;
>  		break;

Getting a mutex lock might sleep, so why not use GFP_KERNEL ?
