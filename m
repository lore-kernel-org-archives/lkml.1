Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbZFSQLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbZFSQLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 12:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZFSQLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 12:11:30 -0400
Received: from mail-fx0-f212.google.com ([209.85.220.212]:45025 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbZFSQL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 12:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=Xh7G4KIt5Wm5dMTg18L6IeKgTCnbGtbmTwuQpf55v13lUoDy8N4y2ZXjv9xlmLS6Ft
         zrkdpexbAdKK+YPosfNu2AyrVHqqdTn5Wc692kmzQp29/vG6HBwBxlq5VVVatat8+mvi
         W/qphl/glPMYTWGjA/zW+TrGblYkkrOfQFB8w=
Message-ID: <4A3BB8B1.9030407@gmail.com>
Date: Fri, 19 Jun 2009 18:11:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.4 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: mchehab@infradead.org
CC: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       ralph@convergence.de, marcus@convergence.de
Subject: sleep in atomic in dvb_dmx_swfilter_packet
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we've found that there is a vmalloc call from atomic context:
dvb_dmx_swfilter_packets
 -> spin_lock()
 -> dvb_dmx_swfilter_packet
   -> vmalloc()
