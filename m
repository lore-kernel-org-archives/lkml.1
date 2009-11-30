Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZK3KmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZK3KmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZK3KmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:42:17 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:41377 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbZK3KmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vTsMjw4g0ml3S3prYtXRFZr6dstJgoHXqUXJGyv2Okzgt56L3ff+zCFpmqfkdxdS7n
         8wY2PRB2tWEK2PY19iHJYDPIhX0oOYrVuTKkn+Hr1gB3nvF9ct95vhYD9v371NoDNPhy
         evuJ4pDI3a3YmJS+T7jnOhZ/Ja36wbxMSahb0=
MIME-Version: 1.0
Date: Mon, 30 Nov 2009 16:12:21 +0530
Message-ID: <b681c62b0911300242u72ef2bb6v8029416fe96367dc@mail.gmail.com>
Subject: finding kernel virtual addr from physical addr of a user buffer
From: yogeshwar sonawane <yogyas@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I want to see/monitor/check/read the data of a user buffer. The idea
is like this :-

There is a network card which is sending/receiving the data. Many
applications are using that card.
Sometimes i am getting an application level error saying received data
is corrupt. I want to see/print send and receive buffer.
Having application level changes for printing is out of scope as there
can be multiple applications running simultaneous.

We have modified our card's firmware so that it will dump the Physical
addresses of user buffers which are sent or received.
After reading the dumped PA, we will pass a single PA to a driver
through sysfs file. Then we will cat the sysfs file which should show
the one page buffer contents corresponding to passed PA.

For this to work, the driver has to have access to the PA. First, i am
finding page frame no. (pfn) by right-shifting PA. Then kmap() is
called using pfn_to_page().
This will give kernel virtual address which can be used to print/show
data during "cat sysfs file" command.

1) Whether the above mentioned steps are correct ? Kindly comment.

2) In the driver store() function, i have modified the contents by
using kernel virtual address. But sometimes i am not able to see the
modified contents at user level.
Kindly suggest what can be the problem ?

3) Kindly suggest any other way to see/check user buffer contents when
PA is available ?

Thanking you,
Yogeshwar
