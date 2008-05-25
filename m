Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYEYD3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYEYD3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 23:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYEYD3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 23:29:16 -0400
Received: from pc125.solomon-systech.com ([202.76.106.125]:46632 "HELO
	virus-gateway.solomon-systech.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752230AbYEYD3Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 23:29:16 -0400
X-Greylist: delayed 3639 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 May 2008 23:29:15 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: kobject_cleanup should set kobject.k_name to NULL?
Date: Sun, 25 May 2008 10:28:06 +0800
Message-ID: <6334E09627481B4AA5C8DE1E69E19D3B0875E648@SSLEXCHANGE.solomonsystech.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kobject_cleanup should set kobject.k_name to NULL?
Thread-Index: Aci7BANFacNtITEJRiS82NIo+U3SuQACp90pAL+k/oA=
From: <sasin@solomon-systech.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux 2.6.24

platform_device_unregister -> device_unregister -> put_device ->
kobject_release -> kobject_cleanup frees kobject.k_name but does not set
it to NULL.  

platform_device_register -> device_register -> device_add ->
kobject_set_name which calls kfree on this element.  Calling kfree with
a NULL pointer is harmless, but in this case it is a NON-NULL freed
pointer, causing misbehaviour.

Currently I call device_(un)register combinations multiple times on a
statically allocated platform device structure to simulate hardware
device arrival/removal, and this results in crashes owing to the
behaviour above.  Should this be considered a bug or am I using it
wrong?

Best regards,
Sasi
