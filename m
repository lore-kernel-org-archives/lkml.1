Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbYFQO6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbYFQO6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758366AbYFQO6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:58:00 -0400
Received: from hs-out-0708.google.com ([64.233.178.251]:57660 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbYFQO57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PKnUrGZw/eMi9/cW/BWuQpcMWKUe9fO4FBmczxtXtiArr7+7XcLoRQmiy/Boj/zc3D
         f6yB07DHi+yFa5qVVaSFvZbJZBbp4BPjZ4PNsbE2obuQvchWpygW1CD06yaVLMJD9+p1
         miSUE2gzu3P2xtSOLFCIbH8yGaSA4ZBrgy9jQ=
Message-ID: <85e7c2fc0806170757t66a1167m9683fd4ad1c36f71@mail.gmail.com>
Date: Tue, 17 Jun 2008 22:57:54 +0800
From: "Bob Zhang" <zhanglinbao@gmail.com>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: Does anyone run AXFS in 2.4 version of kernel ? I am trying my best to apply AXFS patches into 2.4.18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <85e7c2fc0806160720v510a565id709ee782851169d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <85e7c2fc0805090919v613fb823m8dd979b8cd959889@mail.gmail.com>
	 <6934efce0805120923v636d2dbjb062d33fb861f5a2@mail.gmail.com>
	 <85e7c2fc0805131746k5284d66dj7cfac5f9138186e2@mail.gmail.com>
	 <6934efce0805131801s633a1692ha8914a76173c2c80@mail.gmail.com>
	 <85e7c2fc0805190842v6ee5f4f3jef7790b0fa459a21@mail.gmail.com>
	 <85e7c2fc0806160720v510a565id709ee782851169d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today I carefully read the mkfs.axfs.c , I finally make clear about
the axfs is how to organize the structure ,including the spec of super
,and the content of region , and how to store the file content in
different region are .

Jared Hulber is a great programmer , this is a very complex thing .
I am ready for writing a document about I have known for more newbies for axfs.

----
In fact , yesterday , I asked a stupid question to Jared Hulbert , the
information from /proc/axfs/volume0 is engough to create a valid xml
file .

for example ,from
./bin/busybox,0,18

./bin/busybox,28672,2

./bin/busybox,53248,4

./bin/busybox,143360,3

./bin/busybox,147456,3

./bin/busybox,151552,8

./bin/busybox,155648,11

we can know the page of offset 0 is called 18 times ,compared with
other pages , it should be set XIP.
<xipfsmap>
	<file>
		<name>
			./bin/busybox
		</name>
		<chunk>
			<size>4096</size>
			<offset>0</offset>    //maybe we need convert it from /proc info
		</chunk>
	</file>
</xipfsmap>
the advantage of AXFS is that we can set every page to be XIP , so the
size is certainly 4096. but if we think like this , the size item in
the xml is useless, I think maybe Jared Hulber want to provide some
lazy method to set contiguous pages to be XIP , you don't need to
write some chunk . but I feel that the chance of contiguous pages are
read is not high , so for us , setting every page is enough .

if we want to set many pages to be XIP , we should write many chunk items .

Am I right , Mr Hulbert ?

Best Regards,
Bob
