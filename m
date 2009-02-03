Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZBCLNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZBCLNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZBCLNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:13:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:31299 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbZBCLNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:13:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=cnnOx8QAV0QbmL1hQHbNFI1cqmeLgkn3CwrWnKtHfZFcBRAxpm0yEu3+A1xSdMf0YW
         8Td+5gGMdpccYDKzIqzUWaAIGmNzNVe80xshUe2LKGGeBu74aRv91MgBALRUhrevz/dn
         quT0P7KuejySxdcS8ahdavQWKRmPlg02IiRZk=
MIME-Version: 1.0
Date: Tue, 3 Feb 2009 12:13:21 +0100
Message-ID: <b0438a630902030313l1f48bdeasfcca132bf066877c@mail.gmail.com>
Subject: IXP4XX: Assign queues
From: =?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?= <gotzoncabanes@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>, Karl Hiramoto <karl@hiramoto.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have a problem assigning queues to ethernet and HSS. In my system, I
am trying to use both HSS in the NPEA, and ethernet in NPEB and NPEC.
Additionally I am trying to use four HDLC per HSS.

It seems there are fixed some fixed queues, while others can be
changed. I have added a 64 queues patch (not enough queues for all the
devices), and trying not to modify the queues assigned for ethernet in
ixdp425-setup.c

Take a look to the following table (in which I put the changeable
queues between "()").

            txreadyq    rxqueue    txqueue   rxfree    txdone
hdlc0       (32)            13             14         18         22
hdlc1       (36)              0               5          1         22
hdlc2       (33)            13             15         19         22
hdlc3       (37)              0               6          2         22
hdlc4       (34)            13             16         20         22
hdlc5       (38)              0               7          3         22
hdlc6       (35)            13             17         21         22
hdlc7       (39)              0               8          4         22

              rxq      txreadyq    txqueue    rxqueue    txdone
eth0        (3)           (20)           24            28           31
eth1        (4)           (21)           25            27           31

As queues 23 and 26 seem to be reserved for ethernet in NPEA this
result in queues 10, 11, 12, 29 and 30 being free (or reserved for
crypto which I do not use).

So... It seems there is a conflict between queues reserved for rxq and
txreadyq in eth0 and eth1 with queues for rxfree in hdlc4-hdlc7.

As I considered rxq and txreadyq queues in eth0 and eth1 changeable, I
tried assigning them queues 40, 41, 42, and 43 (but the interfaces did
not work anymore). Trying different combinations, I have discovered
that rxq must be bellow 32 (so I have assigned them queues 10 and 11),
while txreadyq can be whatever (40 and 41 in my case).

Am I working in the right direction? If so... Couldn't we agree in a
queue mapping that satisfy all needs so that it must not be changed?

Thanks

Miguel Ángel Álvarez
