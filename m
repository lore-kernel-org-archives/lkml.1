Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbYEJBiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbYEJBiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 21:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYEJBhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 21:37:53 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61054 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752424AbYEJBht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 21:37:49 -0400
Date: Sat, 10 May 2008 02:35:18 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>
cc: David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Alexander Bigga <ab@mycable.de>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       i2c@lm-sensors.org, rtc-linux@googlegroups.com,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/4] RTC: SMBus support for the M41T80
In-Reply-To: <20080509222754.03de1c54@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805100116290.10552@cliff.in.clinika.pl>
References: <200805070120.03821.david-b@pacbell.net>
 <Pine.LNX.4.55.0805072226180.25644@cliff.in.clinika.pl>
 <20080508093456.340a42b0@hyperion.delvare> <Pine.LNX.4.55.0805091917370.10552@cliff.in.clinika.pl>
 <20080509222754.03de1c54@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> Welcome back to the world of the living creatures then. How was the
> other world? :)

 I don't remember, sorry. ;-)

> Really? I don't remember any such rule, so this must have been before
> 2003.

 Could be -- my memory happily still extends back beyond that moment of
time.

> You're wrong in your assumption that adding coding style cleanups to a
> patch is "for free". It makes reviewing the patch more difficult, and it
> makes backporting the patch more difficult, too (cleanups increase the
> risks that the patch won't apply to an older kernel, and you have to
> filter out all cleanups for -stable.) Compared to this, the time spent
> to handle a separate, cleanup-only patch is very small by my maintainer
> experience.

 Now this is certainly a valid point.  But the concept of -stable is
recent enough this is only the second or third time I see it mentioned.

> >                                             I think anybody clever enough
> > to notice an obvious rule having been applied will follow it.
> 
> You're wrong again, sorry. Developers are always in a hurry, they often
> fail to follow the written rules, they just won't care about unwritten
> ones.

 Well, you have spotted one counter-example now who does not hurry enough
for it to spoil his work.  Besides, the time required to put a header
inclusion at the right place in an ordered sequence is the same as for an
insertion at a random position.

> Want an example? Look at MAINTAINERS. It is supposed to be sorted
> alphabetically, the header says so and pretty much everyone should be
> aware of it by now, still you can check by yourself that of the 600
> entries in that file, about 100 are not at the correct place.

 Well, some people do not read user manuals either -- perhaps they have 
missed the annotation too?

> I sure hope that they are all gone by now. Headers which need to
> included in a specific order are a bug.

 Well, this is the first time I hear it stated by someone else.  Good 
progress, I would say...

> I think we have a script to find duplicates. I admit that sorting the
> headers in alphabetical order solve the problem. But OTOH, if
> developers can't be bothered to make sure they don't add a duplicate
> header, I doubt that they can be bothered to keep the includes sorted
> alphabetically.

 Well, if developers cannot be bothered to produce quality results, then
perhaps they should be doing something else?  There is no obligation to be
a software developer, is it?

> >  Ah, I see -- I must have missed it from documentation or perhaps it is
> > somewhat unclear.  You mean our I2C API implies a driver for a
> 
> It's documented in Documentation/i2c/functionality. If something is
> unclear, please let me know and/or send a patch.

 Well, I had a look at this file while writing my changes and this is the 
very thing that is unclear.  The only place the description refers to 
emulation is the I2C_FUNC_SMBUS_EMUL flag and there is nothing said
about any other I2C_FUNC_SMBUS_* flag in the context of emulation.  The 
rest of the file refers to functionality provided by the adapter, which 
can be reasonably assumed to be such provided directly by hardware.

> More exactly: if there is anything to share _and the added cost of
> sharing is less than the benefit_ then it should be done. Additional
> kernel modules have a cost. Even just exporting additional functions,
> has a cost. Going through an interface often has a cost. The benefit on
> the maintenance front must overcome these, otherwise it's not worth
> doing it.

 Having improvements and bug fixes applied to some of the repeated code
sequences only has its cost as well.  If the piece of code is small then
it can go to an inline function and the interface cost is null.  If it is
big, then it can go to a library from which all the interested modules can
import it with no need for an additional module.  Even pieces of code as
small as the Ethernet CRC calculation have been decided worth being put
into a single place even though there is little room for improvement or
breakage there.

 Go chase all the copies of code to support the SCC or the LANCE scattered
throughout our tree and figure out which has the least bugs and/or the
most features if you have any doubts about how to classify code
duplication.

> You assume that there is roughly only one way to emulate reading or
> writing a block from/to an I2C or SMBus device, with only slight
> variations. I would love it the I2C world was that simple, but
> unfortunately it is not. Each device has its own constraints on how a
> block read/write can be emulated. For example on some devices you can
> use word reads as an alternative to block reads, but other devices will
> only accept byte reads as an alternative. Some devices will accept byte
> reads but not at the same address as the block read (see for example
> drivers/hwmon/lm93.c - actually this is mandatory for SMBus block
> reads), etc. So I am still skeptical that we can come up with one or
> more emulation functions that can be used by more than 2 drivers and
> still get the best of each device.

 I am not assuming anything here.  I have only stated that if this
approach to transfers involving a range of commands was useful elsewhere,
then code to do so should not be duplicated throughout all the interested
drivers.  I do not know if there are any other than this -- it is up to
the users and/or maintainers of code in question to determine.

> But well, if you want to give it a try, just go on, prepare a patch,
> and send it for review.

 Will see.  For now here is a new version of the change -- aside taking 
your and other people's comments into account I have improved the logic 
behind required bus adapter's feature determination.

 Everybody interested please give it a try.  It certainly works for me.  
Comments are welcome.  I will submit all the clean-up changes separately,
independently or when the whole set is ready as appropriate, based on
dependencies or the lack of.

  Maciej

patch-2.6.26-rc1-20080505-m41t80-smbus-15
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c	2008-05-05 02:55:40.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c	2008-05-10 00:57:13.000000000 +0000
@@ -6,6 +6,7 @@
  * Based on m41t00.c by Mark A. Greer <mgreer@mvista.com>
  *
  * 2006 (c) mycable GmbH
+ * Copyright (c) 2008  Maciej W. Rozycki
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -36,6 +37,8 @@
 #define M41T80_REG_DAY	5
 #define M41T80_REG_MON	6
 #define M41T80_REG_YEAR	7
+#define M41T80_REG_CONTROL	8
+#define M41T80_REG_WATCHDOG	9
 #define M41T80_REG_ALARM_MON	0xa
 #define M41T80_REG_ALARM_DAY	0xb
 #define M41T80_REG_ALARM_HOUR	0xc
@@ -58,7 +61,7 @@
 #define M41T80_FEATURE_HT	(1 << 0)
 #define M41T80_FEATURE_BL	(1 << 1)
 
-#define DRV_VERSION "0.05"
+#define DRV_VERSION "0.06"
 
 static const struct i2c_device_id m41t80_id[] = {
 	{ "m41t80", 0 },
@@ -78,31 +81,78 @@ struct m41t80_data {
 	struct rtc_device *rtc;
 };
 
-static int m41t80_get_datetime(struct i2c_client *client,
-			       struct rtc_time *tm)
+
+static int m41t80_transfer(struct i2c_client *client, int write,
+			   u8 reg, u8 num, u8 *buf)
 {
-	u8 buf[M41T80_DATETIME_REG_SIZE], dt_addr[1] = { M41T80_REG_SEC };
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
-			.buf	= buf + M41T80_REG_SEC,
-		},
-	};
+	int i, rc;
 
-	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
-		dev_err(&client->dev, "read error\n");
-		return -EIO;
+	if (write) {
+		if (i2c_check_functionality(client->adapter,
+					    I2C_FUNC_SMBUS_WRITE_I2C_BLOCK)) {
+			i = i2c_smbus_write_i2c_block_data(client,
+							   reg, num, buf);
+		} else {
+			for (i = 0; i < num; i++) {
+				rc = i2c_smbus_write_byte_data(client, reg + i,
+							       buf[i]);
+				if (rc < 0) {
+					i = rc;
+					goto out;
+				}
+			}
+		}
+	} else {
+		if (i2c_check_functionality(client->adapter,
+					    I2C_FUNC_SMBUS_READ_I2C_BLOCK)) {
+			i = i2c_smbus_read_i2c_block_data(client,
+							  reg, num, buf);
+		} else {
+			for (i = 0; i < num; i++) {
+				rc = i2c_smbus_read_byte_data(client, reg + i);
+				if (rc < 0) {
+					i = rc;
+					goto out;
+				}
+				buf[i] = rc;
+			}
+		}
 	}
+out:
+	return i;
+}
 
-	tm->tm_sec = BCD2BIN(buf[M41T80_REG_SEC] & 0x7f);
+static int m41t80_get_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	u8 buf[M41T80_DATETIME_REG_SIZE];
+	int loops = 2;
+	int sec0, sec1;
+
+	/*
+	 * Time registers are latched by this chip if an I2C block
+	 * transfer is used, but with SMBus-style byte accesses
+	 * this is not the case, so check seconds for a wraparound.
+	 */
+	do {
+		if (m41t80_transfer(client, 0, M41T80_REG_SEC,
+				    M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
+				    buf + M41T80_REG_SEC) < 0) {
+			dev_err(&client->dev, "read error\n");
+			return -EIO;
+		}
+		sec0 = buf[M41T80_REG_SEC];
+
+		sec1 = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
+		if (sec1 < 0) {
+			dev_err(&client->dev, "read error\n");
+			return -EIO;
+		}
+
+		sec0 = BCD2BIN(sec0 & 0x7f);
+		sec1 = BCD2BIN(sec1 & 0x7f);
+	} while (sec1 < sec0 && --loops);
+
+	tm->tm_sec = sec1;
 	tm->tm_min = BCD2BIN(buf[M41T80_REG_MIN] & 0x7f);
 	tm->tm_hour = BCD2BIN(buf[M41T80_REG_HOUR] & 0x3f);
 	tm->tm_mday = BCD2BIN(buf[M41T80_REG_DAY] & 0x3f);
@@ -117,39 +167,16 @@ static int m41t80_get_datetime(struct i2
 /* Sets the given date and time to the real time clock. */
 static int m41t80_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
-	u8 wbuf[1 + M41T80_DATETIME_REG_SIZE];
-	u8 *buf = &wbuf[1];
-	u8 dt_addr[1] = { M41T80_REG_SEC };
-	struct i2c_msg msgs_in[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
-			.buf	= buf + M41T80_REG_SEC,
-		},
-	};
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1 + M41T80_DATETIME_REG_SIZE,
-			.buf	= wbuf,
-		 },
-	};
+	u8 buf[M41T80_DATETIME_REG_SIZE];
 
 	/* Read current reg values into buf[1..7] */
-	if (i2c_transfer(client->adapter, msgs_in, 2) < 0) {
+	if (m41t80_transfer(client, 0, M41T80_REG_SEC,
+			    M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
+			    buf + M41T80_REG_SEC) < 0) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
 
-	wbuf[0] = 0; /* offset into rtc's regs */
 	/* Merge time-data and register flags into buf[0..7] */
 	buf[M41T80_REG_SSEC] = 0;
 	buf[M41T80_REG_SEC] =
@@ -167,7 +194,8 @@ static int m41t80_set_datetime(struct i2
 	/* assume 20YY not 19YY */
 	buf[M41T80_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
 
-	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
+	if (m41t80_transfer(client, 1, M41T80_REG_SSEC,
+			    M41T80_DATETIME_REG_SIZE, buf) < 0) {
 		dev_err(&client->dev, "write error\n");
 		return -EIO;
 	}
@@ -241,34 +269,11 @@ err:
 static int m41t80_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	u8 wbuf[1 + M41T80_ALARM_REG_SIZE];
-	u8 *buf = &wbuf[1];
+	u8 buf[M41T80_ALARM_REG_SIZE];
 	u8 *reg = buf - M41T80_REG_ALARM_MON;
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
-	struct i2c_msg msgs_in[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_ALARM_REG_SIZE,
-			.buf	= buf,
-		},
-	};
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1 + M41T80_ALARM_REG_SIZE,
-			.buf	= wbuf,
-		 },
-	};
 
-	if (i2c_transfer(client->adapter, msgs_in, 2) < 0) {
+	if (m41t80_transfer(client, 0, M41T80_REG_ALARM_MON,
+			    M41T80_ALARM_REG_SIZE, buf) < 0) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
@@ -278,7 +283,6 @@ static int m41t80_rtc_set_alarm(struct d
 	reg[M41T80_REG_ALARM_MIN] = 0;
 	reg[M41T80_REG_ALARM_SEC] = 0;
 
-	wbuf[0] = M41T80_REG_ALARM_MON; /* offset into rtc's regs */
 	reg[M41T80_REG_ALARM_SEC] |= t->time.tm_sec >= 0 ?
 		BIN2BCD(t->time.tm_sec) : 0x80;
 	reg[M41T80_REG_ALARM_MIN] |= t->time.tm_min >= 0 ?
@@ -292,7 +296,8 @@ static int m41t80_rtc_set_alarm(struct d
 	else
 		reg[M41T80_REG_ALARM_DAY] |= 0x40;
 
-	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
+	if (m41t80_transfer(client, 1, M41T80_REG_ALARM_MON,
+			    M41T80_ALARM_REG_SIZE, buf) < 0) {
 		dev_err(&client->dev, "write error\n");
 		return -EIO;
 	}
@@ -312,24 +317,10 @@ static int m41t80_rtc_read_alarm(struct 
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	u8 buf[M41T80_ALARM_REG_SIZE + 1]; /* all alarm regs and flags */
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
 	u8 *reg = buf - M41T80_REG_ALARM_MON;
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_ALARM_REG_SIZE + 1,
-			.buf	= buf,
-		},
-	};
 
-	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
+	if (m41t80_transfer(client, 0, M41T80_REG_ALARM_MON,
+			    M41T80_ALARM_REG_SIZE + 1, buf) < 0) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
@@ -488,26 +479,16 @@ static int boot_flag;
  */
 static void wdt_ping(void)
 {
-	unsigned char i2c_data[2];
-	struct i2c_msg msgs1[1] = {
-		{
-			.addr	= save_client->addr,
-			.flags	= 0,
-			.len	= 2,
-			.buf	= i2c_data,
-		},
-	};
-	i2c_data[0] = 0x09;		/* watchdog register */
+	u8 wdt = 0x80;				/* WDS = 1 (0x80)  */
 
 	if (wdt_margin > 31)
-		i2c_data[1] = (wdt_margin & 0xFC) | 0x83; /* resolution = 4s */
+		/* mulitplier = WD_TIMO / 4, resolution = 4s (0x3)  */
+		wdt |= (wdt_margin & 0xfc) | 0x3;
 	else
-		/*
-		 * WDS = 1 (0x80), mulitplier = WD_TIMO, resolution = 1s (0x02)
-		 */
-		i2c_data[1] = wdt_margin<<2 | 0x82;
+		/* mulitplier = WD_TIMO, resolution = 1s (0x2)  */
+		wdt |= wdt_margin << 2 | 0x2;
 
-	i2c_transfer(save_client->adapter, msgs1, 1);
+	i2c_smbus_write_byte_data(save_client, M41T80_REG_WATCHDOG, wdt);
 }
 
 /**
@@ -517,36 +498,8 @@ static void wdt_ping(void)
  */
 static void wdt_disable(void)
 {
-	unsigned char i2c_data[2], i2c_buf[0x10];
-	struct i2c_msg msgs0[2] = {
-		{
-			.addr	= save_client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= i2c_data,
-		},
-		{
-			.addr	= save_client->addr,
-			.flags	= I2C_M_RD,
-			.len	= 1,
-			.buf	= i2c_buf,
-		},
-	};
-	struct i2c_msg msgs1[1] = {
-		{
-			.addr	= save_client->addr,
-			.flags	= 0,
-			.len	= 2,
-			.buf	= i2c_data,
-		},
-	};
-
-	i2c_data[0] = 0x09;
-	i2c_transfer(save_client->adapter, msgs0, 2);
-
-	i2c_data[0] = 0x09;
-	i2c_data[1] = 0x00;
-	i2c_transfer(save_client->adapter, msgs1, 1);
+	i2c_smbus_read_byte_data(save_client, M41T80_REG_WATCHDOG);
+	i2c_smbus_write_byte_data(save_client, M41T80_REG_WATCHDOG, 0);
 }
 
 /**
@@ -736,13 +689,25 @@ static int m41t80_probe(struct i2c_clien
 	struct rtc_device *rtc = NULL;
 	struct rtc_time tm;
 	struct m41t80_data *clientdata = NULL;
+	u32 func;
+	int reg;
 
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
-				     | I2C_FUNC_SMBUS_BYTE_DATA)) {
+	func = i2c_get_functionality(client->adapter);
+	if (!(func & (I2C_FUNC_SMBUS_READ_I2C_BLOCK |
+		      I2C_FUNC_SMBUS_READ_BYTE)) ||
+	    !(func & (I2C_FUNC_SMBUS_WRITE_I2C_BLOCK |
+		      I2C_FUNC_SMBUS_WRITE_BYTE))) {
 		rc = -ENODEV;
 		goto exit;
 	}
 
+	/* Trivially check it's there; keep the result for the HT check. */
+	reg = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
+	if (reg < 0) {
+		rc = -ENXIO;
+		goto exit;
+	}
+
 	dev_info(&client->dev,
 		 "chip found, driver version " DRV_VERSION "\n");
 
@@ -765,11 +730,7 @@ static int m41t80_probe(struct i2c_clien
 	i2c_set_clientdata(client, clientdata);
 
 	/* Make sure HT (Halt Update) bit is cleared */
-	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
-	if (rc < 0)
-		goto ht_err;
-
-	if (rc & M41T80_ALHOUR_HT) {
+	if (reg & M41T80_ALHOUR_HT) {
 		if (clientdata->features & M41T80_FEATURE_HT) {
 			m41t80_get_datetime(client, &tm);
 			dev_info(&client->dev, "HT bit was set!\n");
@@ -782,18 +743,18 @@ static int m41t80_probe(struct i2c_clien
 		}
 		if (i2c_smbus_write_byte_data(client,
 					      M41T80_REG_ALARM_HOUR,
-					      rc & ~M41T80_ALHOUR_HT) < 0)
+					      reg & ~M41T80_ALHOUR_HT) < 0)
 			goto ht_err;
 	}
 
 	/* Make sure ST (stop) bit is cleared */
-	rc = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
-	if (rc < 0)
+	reg = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
+	if (reg < 0)
 		goto st_err;
 
-	if (rc & M41T80_SEC_ST) {
+	if (reg & M41T80_SEC_ST) {
 		if (i2c_smbus_write_byte_data(client, M41T80_REG_SEC,
-					      rc & ~M41T80_SEC_ST) < 0)
+					      reg & ~M41T80_SEC_ST) < 0)
 			goto st_err;
 	}
 
