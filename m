Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbZC3SyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbZC3SyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZC3SyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:54:04 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36297 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZC3SyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:54:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jdW6nSVEGoC5eRWSQb8+G8PdzkDWWB6jnYhxGpcGyE3ZPhvkZ/uMRGo3JGz/TQNgim
         es4o+EQpiiZizmD7kgE1YVfiUMhXA4FhI3WL8d0sC0OsVgvShIRqvwj5FkuHOR56h7o+
         8bRKrvMxEmJ9N6RWNQJ3R2JSeh2MEbqZTK8nM=
MIME-Version: 1.0
In-Reply-To: <49D11096.3070804@vlnb.net>
References: <49D10256.8030307@vlnb.net>
	 <e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>
	 <49D11096.3070804@vlnb.net>
Date: Mon, 30 Mar 2009 20:53:58 +0200
Message-ID: <e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGT data)
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: scst-devel <scst-devel@lists.sourceforge.net>,
       iscsitarget-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, stgt@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 8:33 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> Bart Van Assche, on 03/30/2009 10:06 PM wrote:
>> These are indeed interesting results. There are some aspects of the
>> test setup I do not understand however:
>> * All tests have been run with buffered I/O instead of direct I/O
>> (iflag=direct / oflag=direct). My experience is that the results of
>> tests with direct I/O are easier to reproduce (less variation between
>> runs). So I have been wondering why the tests have been run with
>> buffered I/O instead ?
>
> Real applications use buffered I/O, hence it should be used in tests. It
>  evaluates all the storage stack on both initiator and target as a whole.
> The results are very reproducible, variation is about 10%.

Most applications do indeed use buffered I/O. Database software
however often uses direct I/O. It might be interesting to publish
performance results for both buffered I/O and direct I/O. A quote from
the paper "Asynchronous I/O Support in Linux 2.5" by Bhattacharya e.a.
(Linux Symposium, Ottawa, 2003):

Direct I/O (raw and O_DIRECT) transfers data between a user buffer and
a device without copying the data through the kernel’s buffer cache.
This mechanism can boost performance if the data is unlikely to be
used again in the short term (during a disk backup, for example), or
for applications such as large database management systems that
perform their own caching.

Bart.
