Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbXLUFm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbXLUFm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 00:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbXLUFmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 00:42:51 -0500
Received: from web51107.mail.re2.yahoo.com ([206.190.38.149]:28536 "HELO
	web51107.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750977AbXLUFmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 00:42:50 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2007 00:42:50 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=kFmZS/MXWR/BGFNmAK1Pd/6xYInEbRs2ugcA/Gigu/f1Vvb8i9iqnOb4Ub+bMltzOFFpd+5KlpAz6ztGEiUD7a3Cop/ftLaV47uLBiIMG8DUZ+TurbrvSnN5RVgFEckBAR0DqSO27zbAEODoldAWa8SKPsqXsRy9pNCaOMsHa2Q=;
X-YMail-OSG: RXvgrRIVM1l1fQQkeAdwTVYI56OhL5_9Ht7gw4s_0IPsoI8r7ziUs44RRznHPfJbxm1kVlD09Tn3z1d_6hbjaJOmIr5Z.cuwgNsUv59luhhpHDb1nPi2jWBe5VAaIkCZFw21iPPiwgah.lc-
X-Mailer: YahooMailRC/818.31 YahooMailWebService/0.7.158.1
Date: Thu, 20 Dec 2007 21:36:09 -0800 (PST)
From: Venkat Subbiah <venkat_sr@yahoo.com>
Subject: i2c block read on an SMBus
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <570842.52526.qm@web51107.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to do an i2c block read using a call like 

    rc = i2c_smbus_xfer(g_i2c_adp, buf[0], 0x0,
                  I2C_SMBUS_READ, 0x0,
                  I2C_SMBUS_I2C_BLOCK_DATA, &data);

and the logs show me that this hits the else part of this if condition in i801_block_transaction function in file  i2c-i801.c. (of kernel version 2.6.23.11)

    if (command == I2C_SMBUS_I2C_BLOCK_DATA) {
        if (read_write == I2C_SMBUS_WRITE) {
            /* set I2C_EN bit in configuration register */
            pci_read_config_byte(I801_dev, SMBHSTCFG, &hostc);
            pci_write_config_byte(I801_dev, SMBHSTCFG,
                          hostc | SMBHSTCFG_I2C_EN);
        } else {
            dev_err(&I801_dev->dev,
                "I2C_SMBUS_I2C_BLOCK_READ not DB!\n");
            return -1;
        }
    }

some time ago when I was doing a web search i seem to have run into a patch which allows doing a i2c block read on SMBus. Is there a patch for this? 
( Output from my lspci: 00:1f.3 SMBus: Intel Corporation 6300ESB SMBus Controller (rev 02))


Looking at the documentation for 6300ESB SMBus Controller it seems that
the only I2C read transaction supported is a block read. All the other
read transaction are SMBus type. 

Why is the i2c read block not supported in the driver? 

Thanks in advance for all the input.  Please CC me on th replies as I am not subscribed to the list.


Thx,
Venkat


