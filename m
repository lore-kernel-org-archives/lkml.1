Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYIDMJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYIDMJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbYIDMJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:09:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:38589 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYIDMJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O2aOha4qdYdFI4unISHO0cxO0ZOAJXzQNPBPSoRDuUBco6I1c9tCzaTZPzgfyQnk9+
         Uua+fC3UUwWbhmaRvSeR/MjLdiDFBdDh7GEF0q3XwEI2A/H3TtcCGRoHxaK2K+xf/C2a
         d+y6n1GfvKGZQedKMNbUTgRCRcR46LzUObk10=
Message-ID: <82ecf08e0809040509v323a3065h68a2e72dc86f23ac@mail.gmail.com>
Date: Thu, 4 Sep 2008 09:09:34 -0300
From: "Thiago Galesi" <thiagogalesi@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device 152d:2338
Cc: "Alex Buell" <alex.buell@munted.org.uk>, linux-kernel@vger.kernel.org,
       "Robert Hancock" <hancockr@shaw.ca>, "Tomas Styblo" <tripie@cpan.org>,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
In-Reply-To: <Pine.LNX.4.44L0.0809021654330.5583-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82ecf08e0809021316l68272103q9daff7b12ed90e8b@mail.gmail.com>
	 <Pine.LNX.4.44L0.0809021654330.5583-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I looked into this a little bit further...

K3B provides an interesting log:

first, this is repeated 3 times:

(K3bDevice::ScsiCommand) failed:
                           command:    MODE SELECT (55)
                           errorcode:  70
                           sense key:  ILLEGAL REQUEST (5)
                           asc:        26
                           ascq:       0

then it shows:

(K3bDevice::ScsiCommand) failed:
                           command:    GET PERFORMANCE (ac)
                           errorcode:  0
                           sense key:  NO SENSE (2)
                           asc:        0
                           ascq:       0
(K3bDevice::Device) /dev/scd0: GET PERFORMANCE length det failed.

And then all commands from then on fail

strace indicate this is sent via SG_IO IOCTL (unfortunatelly, strace
doen't show the contents in the ioctl)

I don't know if the device is supposed to stop working when receiving
an unkown command (like it is apparently doing), also because
apparently cdrecord doesn't send this command but fails anyway

-- 
-
Thiago Galesi
