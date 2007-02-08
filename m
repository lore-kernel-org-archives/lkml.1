Return-Path: <linux-kernel-owner+w=401wt.eu-S1423208AbXBHKoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423208AbXBHKoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 05:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423209AbXBHKoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 05:44:12 -0500
Received: from truxi.wincor-nixdorf.com ([217.115.67.78]:43875 "EHLO
	truxi.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423208AbXBHKoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 05:44:11 -0500
X-Greylist: delayed 2466 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 05:44:11 EST
Message-ID: <45CAE5A1.80409@wincor-nixdorf.com>
Date: Thu, 08 Feb 2007 09:56:01 +0100
From: Frank Salomon <frank.salomon@wincor-nixdorf.com>
Reply-To: frank.salomon@wincor-nixdorf.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624 Netscape/7.1
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: EV_MSC / driver/input/input.c (Input Handler)
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I had written an additional input_handler :

      static struct input_device_id pcraw_ids[] = {
	     {
                      .flags = INPUT_DEVICE_ID_MATCH_EVBIT,
                      .evbit = { BIT(EV_MSC) },
              },
	     { },    /* Terminating entry */
      };

to get MSC_RAW events from the atkeyboard :

      input_event (&atkbd->dev, EV_MSC, MSC_RAW, code)

But I only get these events :

      input_event(&atkbd->dev, EV_MSC, MSC_SCAN, code);

I know the reason is in driver/input/input.c :

      case EV_MSC:
           if (code > MSC_MAX || !test_bit(code, dev->mscbit))
                return;

           if (dev->event) dev->event(dev, type, code, value);
           break;

because of (driver/input/keyboard/atkbd.c):

      atkbd->dev.mscbit[0] = atkbd->softraw ? BIT(MSC_SCAN) :
           BIT(MSC_RAW) | BIT(MSC_SCAN);

I would like to change driver/input/input.c like this :

      case EV_MSC:
           if (code > MSC_MAX)
                return;

           if (test_bit(code, dev->mscbit))
                if (dev->event) dev->event(dev, type, code, value);
           break;

Any comments ? Maybe I misunderstand the concept of the input events. In 
that case, please give me a short description or let me know were I can 
find any documentation.

Best regards, Frank






