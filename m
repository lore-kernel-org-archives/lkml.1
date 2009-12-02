Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZLBNmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZLBNmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZLBNmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:42:04 -0500
Received: from smtp.nokia.com ([192.100.122.230]:35059 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZLBNmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:42:02 -0500
Date: Wed, 2 Dec 2009 15:41:44 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Amit Kucheria <amit.kucheria@verdurent.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       List Linux Omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] mfd: twl4030: clarify the return value for read and
 write
Message-ID: <20091202134144.GL1361@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1259760678-18707-1-git-send-email-amit.kucheria@verdurent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1259760678-18707-1-git-send-email-amit.kucheria@verdurent.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Dec 2009 13:42:02.0163 (UTC) FILETIME=[3A565030:01CA7355]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 02, 2009 at 02:31:18PM +0100, ext Amit Kucheria wrote:
>@@ -298,10 +298,12 @@ int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
> 	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 1);
> 	mutex_unlock(&twl->xfer_lock);
>
>-	/* i2cTransfer returns num messages.translate it pls.. */
>-	if (ret >= 0)
>-		ret = 0;
>-	return ret;
>+	/* i2c_transfer returns number of messages transferred */
>+	if (ret != 1) {
>+		pr_err("%s: twl4030_i2c_write failed to transfer all messages\n", DRIVER_NAME);

this line is over 80-chars

>+		return ret;
>+	} else

you should have {} here as well.

>+		return 0;
> }
> EXPORT_SYMBOL(twl4030_i2c_write);
>
>@@ -350,10 +352,13 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
> 	ret = i2c_transfer(twl->client->adapter, twl->xfer_msg, 2);
> 	mutex_unlock(&twl->xfer_lock);
>
>-	/* i2cTransfer returns num messages.translate it pls.. */
>-	if (ret >= 0)
>-		ret = 0;
>-	return ret;
>+	/* i2c_transfer returns number of messages transferred */
>+	if (ret != 2) {
>+		pr_err("%s: twl4030_i2c_read failed to transfer all messages\n", DRIVER_NAME);

over 80-chars

>+		return ret;
>+	}
>+	else

} else {

>+		return 0;

}

-- 
balbi
