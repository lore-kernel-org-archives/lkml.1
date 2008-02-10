Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbYBJJ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbYBJJ5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 04:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbYBJJ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 04:57:12 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:63088 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbYBJJ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 04:57:11 -0500
Message-ID: <47AEC941.1070504@student.ltu.se>
Date: Sun, 10 Feb 2008 10:52:01 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: caglar@pardus.org.tr
CC: linux-kernel@vger.kernel.org, davem@davemloft.net,
       torvalds@linux-foundation.org, hidave.darkstar@gmail.com,
       marcel@holtmann.org
Subject: Re: [PATCH] Silent compiler warning introduced by acea6852f32b8805e166d885ed7e9f0c7cd10d41
 ([BLUETOOTH]: Move children of connection device to NULL before connection
 down.)
References: <200802100457.20143.caglar@pardus.org.tr>
In-Reply-To: <200802100457.20143.caglar@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

S.Çağlar Onur wrote:
> Hi;
>
> Following patch silents
>
> net/bluetooth/hci_sysfs.c: In function `del_conn':
> net/bluetooth/hci_sysfs.c:339: warning: suggest parentheses around assignment used as truth value
>
> compiler warning introduced by commit acea6852f32b8805e166d885ed7e9f0c7cd10d41 ([BLUETOOTH]: Move children of connection device to NULL before connection down.)
>
> Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
>
>  net/bluetooth/hci_sysfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
> index e13cf5e..d2d1e4f 100644
> --- a/net/bluetooth/hci_sysfs.c
> +++ b/net/bluetooth/hci_sysfs.c
> @@ -336,7 +336,7 @@ static void del_conn(struct work_struct *work)
>  	struct device *dev;
>  	struct hci_conn *conn = container_of(work, struct hci_conn, work);
>  
> -	while (dev = device_find_child(&conn->dev, NULL, __match_tty)) {
> +	while ((dev = device_find_child(&conn->dev, NULL, __match_tty)) != NULL) {
>   
Why do you need '!= NULL'?

