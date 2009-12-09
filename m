Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZLIOie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZLIOie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZLIOic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:38:32 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:33117 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbZLIOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:38:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GB+C6am9QasCyVmOemm26bc9hYgBEDFt9zQK+tAVhM9yLQMOjpiGfmlT6F9MhYwqxF
         1p2k5t11e/dqf73I3bxc0Nb4dGk82v4Mt7k3kXZOT4ON4T7cls3XBt/NzDwarGvwoaN/
         sZel6G2KqQ7XIXzagr/TzfFoyqbbJdiURwIJw=
Date: Wed, 9 Dec 2009 11:35:40 -0300
From: Rudy Matela <rudy.matela@gmail.com>
To: Jan Yenya Kasprzak <kas@fi.muni.cz>, Krzysztof Halasa <khc@pm.waw.pl>,
       trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] Coding style correction on some drivers that use Generic
 HDLC
Message-ID: <20091209143540.GA9620@vacuum.larces.uece.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a space separating some if/switch/while keywords from the following
parenthesis to conform to the CodingStyle.

Signed-off-by: Rudy Matela <rudy.matela@gmail.com>
---

 drivers/net/wan/cosa.c       |   10 +++++-----
 drivers/net/wan/hdlc_cisco.c |    8 ++++----
 drivers/net/wan/hdlc_x25.c   |    4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index b36bf96..f0bd70f 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -811,7 +811,7 @@ static ssize_t cosa_read(struct file *file,
 	cosa_enable_rx(chan);
 	spin_lock_irqsave(&cosa->lock, flags);
 	add_wait_queue(&chan->rxwaitq, &wait);
-	while(!chan->rx_status) {
+	while (!chan->rx_status) {
 		current->state = TASK_INTERRUPTIBLE;
 		spin_unlock_irqrestore(&cosa->lock, flags);
 		schedule();
@@ -896,7 +896,7 @@ static ssize_t cosa_write(struct file *file,
 
 	spin_lock_irqsave(&cosa->lock, flags);
 	add_wait_queue(&chan->txwaitq, &wait);
-	while(!chan->tx_status) {
+	while (!chan->tx_status) {
 		current->state = TASK_INTERRUPTIBLE;
 		spin_unlock_irqrestore(&cosa->lock, flags);
 		schedule();
@@ -1153,7 +1153,7 @@ static int cosa_ioctl_common(struct cosa_data *cosa,
 	struct channel_data *channel, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
-	switch(cmd) {
+	switch (cmd) {
 	case COSAIORSET:	/* Reset the device */
 		if (!capable(CAP_NET_ADMIN))
 			return -EACCES;
@@ -1704,7 +1704,7 @@ static inline void tx_interrupt(struct cosa_data *cosa, int status)
 			spin_unlock_irqrestore(&cosa->lock, flags);
 			return;
 		}
-		while(1) {
+		while (1) {
 			cosa->txchan++;
 			i++;
 			if (cosa->txchan >= cosa->nchannels)
@@ -2010,7 +2010,7 @@ again:
 static void debug_status_in(struct cosa_data *cosa, int status)
 {
 	char *s;
-	switch(status & SR_CMD_FROM_SRP_MASK) {
+	switch (status & SR_CMD_FROM_SRP_MASK) {
 	case SR_UP_REQUEST:
 		s = "RX_REQ";
 		break;
diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index f1bff98..1ceccf1 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -141,7 +141,7 @@ static __be16 cisco_type_trans(struct sk_buff *skb, struct net_device *dev)
 	    data->address != CISCO_UNICAST)
 		return cpu_to_be16(ETH_P_HDLC);
 
-	switch(data->protocol) {
+	switch (data->protocol) {
 	case cpu_to_be16(ETH_P_IP):
 	case cpu_to_be16(ETH_P_IPX):
 	case cpu_to_be16(ETH_P_IPV6):
@@ -190,7 +190,7 @@ static int cisco_rx(struct sk_buff *skb)
 		cisco_data = (struct cisco_packet*)(skb->data + sizeof
 						    (struct hdlc_header));
 
-		switch(ntohl (cisco_data->type)) {
+		switch (ntohl (cisco_data->type)) {
 		case CISCO_ADDR_REQ: /* Stolen from syncppp.c :-) */
 			in_dev = dev->ip_ptr;
 			addr = 0;
@@ -245,8 +245,8 @@ static int cisco_rx(struct sk_buff *skb)
 
 			dev_kfree_skb_any(skb);
 			return NET_RX_SUCCESS;
-		} /* switch(keepalive type) */
-	} /* switch(protocol) */
+		} /* switch (keepalive type) */
+	} /* switch (protocol) */
 
 	printk(KERN_INFO "%s: Unsupported protocol %x\n", dev->name,
 	       ntohs(data->protocol));
diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index aa9248f..6e1ca25 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -202,10 +202,10 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 		return 0; /* return protocol only, no settable parameters */
 
 	case IF_PROTO_X25:
-		if(!capable(CAP_NET_ADMIN))
+		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
 
-		if(dev->flags & IFF_UP)
+		if (dev->flags & IFF_UP)
 			return -EBUSY;
 
 		result=hdlc->attach(dev, ENCODING_NRZ,PARITY_CRC16_PR1_CCITT);
