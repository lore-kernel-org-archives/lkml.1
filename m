Return-Path: <linux-kernel-owner+w=401wt.eu-S1750999AbXCHGQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbXCHGQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 01:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXCHGQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 01:16:00 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:4652 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbXCHGP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 01:15:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=g+CRHbLdvKkvYAXoSRNTHBGphCVyncskZLzEuI/qzA5comfa3Yc7Itmu6yFmWHm3OvrOpQuLZDmrdmeAYcKbcibOSxT5lhtBlRNFVK+tVMzbH6oXACutU7By08dkiG/z7gF778izR6C4H1qUqms3cQnsfM8FsFVfoU+UBxyjOTk=
Message-ID: <4c348ac20703072215x63a7a315kd018e433c7a197d2@mail.gmail.com>
Date: Thu, 8 Mar 2007 11:45:58 +0530
From: "Kanhu Rauta" <choiskanhu@gmail.com>
To: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org,
       kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Subject: IP Defragmentation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I am using kernel 2.6.20.1. I have written a module,which will
register a function at local_in hook, i have found a strange behavior
with the packets getting in my callback function i.e

[let say i am sending 1500 bytes to this machine from the network]
ping -s 1500 <ip>

1>in case of fragmention i am getting only one packet at the
hook,While analyzing the ip header it says this is the assembled
packet(skb->len=1528,offset=0,MF=0).

While dumping the data(for 0 to 1528 print skb->data[i]) it shows that
only 1472 bytes are valid data and rest 28 bytes are something
garbage.
I verified this with ethereal.

2>I have dumped these packets in ip_local_deliver function after
ip_defrag and before NF_HOOK,But the result is same.

Can Anybody let me know why i am not getting the complete data ?

Regards,
kanhu
