Return-Path: <linux-kernel-owner+w=401wt.eu-S1762712AbYBZTik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762712AbYBZTik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYBZTic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:38:32 -0500
Received: from senator.holtmann.net ([87.106.208.187]:33932 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYBZTib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:38:31 -0500
Cc: Quel Qun <kelk1@comcast.net>, David Woodhouse <dwmw2@infradead.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Message-Id: <88042B50-9057-4589-ADF0-E37A2096BD54@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802260926550.7583@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] bluetooth: delete timer in l2cap_conn_del()
Date: Tue, 26 Feb 2008 20:38:25 +0100
References: <022620080003.1247.47C35750000085C8000004DF2207300793CE05040A05@comcast.net> <alpine.LFD.1.00.0802260926550.7583@apollo.tec.linutronix.de>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Quel,

> Delete a possibly armed timer before kfree'ing the connection object.
>
> Solves: http://lkml.org/lkml/2008/2/15/514
>
> Reported-by:Quel Qun <kelk1@comcast.net>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> ---
> net/bluetooth/l2cap.c |    2 ++
> 1 file changed, 2 insertions(+)
>
> Index: linux-2.6/net/bluetooth/l2cap.c
> ===================================================================
> --- linux-2.6.orig/net/bluetooth/l2cap.c
> +++ linux-2.6/net/bluetooth/l2cap.c
> @@ -417,6 +417,8 @@ static void l2cap_conn_del(struct hci_co
> 		l2cap_sock_kill(sk);
> 	}
>
> +	del_timer_sync(&conn->info_timer);
> +
> 	hcon->l2cap_data = NULL;
> 	kfree(conn);
> }

can you confirm that this actually fixes the issue.

Thomas, if confirmed, this is Acked-by me.

Regards

Marcel

