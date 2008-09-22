Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYIVN2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYIVN2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYIVN2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:28:16 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:37020 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYIVN2P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:28:15 -0400
X-IronPort-AV: E=Sophos;i="4.32,446,1217808000"; 
   d="scan'208";a="20460438"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: Kernel-2.6.22 ntp bug
Date: Mon, 22 Sep 2008 15:28:12 +0200
Message-ID: <8C22373EA650AF40928EEA0C188D62D207ADDB63@xmb-ams-338.emea.cisco.com>
In-Reply-To: <8C22373EA650AF40928EEA0C188D62D207ADD8C8@xmb-ams-338.emea.cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Kernel-2.6.22 ntp bug
Thread-Index: AckckpDl2KBmDCP+TlCmlRrgY+aSRgAJBtLA
References: <8C22373EA650AF40928EEA0C188D62D207ADD8C8@xmb-ams-338.emea.cisco.com>
From: "Hanoch Haim (hhaim)" <hhaim@cisco.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Sep 2008 13:28:14.0438 (UTC) FILETIME=[10DE8060:01C91CB7]
Authentication-Results: ams-dkim-1; header.From=hhaim@cisco.com; dkim=pass (
	sig from cisco.com/amsdkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another option is to change all the drivers to be interrupts safe  

Hanoh

-----Original Message-----
From: Hanoch Haim (hhaim) 
Sent: Monday, September 22, 2008 12:07 PM
To: linux-kernel@vger.kernel.org
Cc: cl@linux-foundation.org; Hanoch Haim (hhaim)
Subject: Kernel-2.6.22 ntp bug

Hi All, I'm new to this mailing list.


I think there is a bug in the kernel/time/ntp.c 


The code call to the function update_persistent_clock(struct timespec
now); the driver below might be implement with i2c (driver of rtc )
which is not interrupt safe.

I have changed the ntp to use work_queue what do you think ?



attached the changed code:



+ fail = dpc_update_persistent_clock(now);


instead of

- update_persistent_clock(now); // this is called to function that might
be block. you can't do that in interrupt context 

the function call schedule_work



extern int dpc_update_persistent_clock(struct timespec now){

my_ntp.now=now;

return(schedule_work(&my_ntp.update_rtc_queue));

}


another option is to change the wrapper function for the set_rtc_xx but
in this case you will need to change all the platforms that uses it (
powerpc)


Hanoh
