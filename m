Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0CBAIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 19:08:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48030 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab0CBAIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 19:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=sMOxRDoxeX/8b5tP5vrKSmbZvDT0XIbNjTsW4fYlha7FfmzmNJVgSqylMTwIDtfr/R
         VNYXzuhkFs0e2WAIm9+MFWAIJCE5qWOW5kiih6G1gYJndHpuabs1i7/7LbBKDC7LazHI
         15i7FS1QRkk2QVqWeBguG2IBm5A7lDwXiRny0=
Message-ID: <4B8C56F0.5090700@gmail.com>
Date: Tue, 02 Mar 2010 02:08:16 +0200
From: Oleg Kutkov <elenbert@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Notifier chains bug ?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I try to used notifier chains for monitoring network devices events.
All works perfectly when just i'm connecting/disconnecting network cable 
or up/down interface via ifconfig.
But when i try to change interface address - nothing happens. Notifier 
is don't send any events :(
There is many events in notifier.h:

#define NETDEV_UP                                        0x0001   
#define NETDEV_DOWN                                 0x0002
#define NETDEV_REBOOT                              0x0003   
#define NETDEV_CHANGE                             0x0004 
#define NETDEV_REGISTER                          0x0005
#define NETDEV_UNREGISTER                    0x0006
#define NETDEV_CHANGEMTU                    0x0007
#define NETDEV_CHANGEADDR                  0x0008
#define NETDEV_GOING_DOWN                  0x0009
#define NETDEV_CHANGENAME                 0x000A
#define NETDEV_FEAT_CHANGE                 0x000B
#define NETDEV_BONDING_FAILOVER      0x000C
#define NETDEV_PRE_UP                               0x000D
#define NETDEV_BONDING_OLDTYPE        0x000E
#define NETDEV_BONDING_NEWTYPE       0x000F

So i receive only NETDEV_UP  and NETDEV_DOWN events.

Part of my code:

//event handler
static int ifEventListener(struct notifier_block *nb, unsigned long 
event, void *ptr);

//set handler
struct notifier_block nbListener =
{
    .notifier_call = ifEventListener
};

//event handler
static int ifEventListener(struct notifier_block *this, unsigned long 
event, void *ptr)
{
    struct net_device *dev = (struct net_device *) ptr;

    printk(KERN_INFO "eventListener() -- %d event from net_device '%s' 
(0x%08X)\n", event, dev->name, (unsigned) dev);
 
    return 0;
}

//register handler
register_netdevice_notifier(&nbListener);



So, this is a bug in notifier or something wrong with my code ?
Thank for any help

-- 
Best regards, 
Oleg

