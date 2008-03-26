Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbYCZIma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbYCZIma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 04:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYCZImW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 04:42:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:25139 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbYCZImV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 04:42:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UyxjVm6UV6CJ6WwI0XAsjiOfWIFdJQzTbrjddPOQKxXaORiuO5FY5bJ2rS4dbXYEHjYNsVAfTFVg0pZu7hZjEfz/BeMXSZJ+/OEH6UYaLju17FhgEgCnJV5Qrt50iatzPwvhVb9iI41Yxyl1fYXSc7JB21yReGwpC2JiPOsqhp4=
Message-ID: <e2e108260803260142o34c33e7ajf395d5cb62824cb4@mail.gmail.com>
Date: Wed, 26 Mar 2008 09:42:19 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Emmanuel Florac" <eflorac@intellique.com>
Subject: Re: RAID-1 performance under 2.4 and 2.6
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080325194306.4ac71ff2@galadriel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080325194306.4ac71ff2@galadriel.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 7:43 PM, Emmanuel Florac <eflorac@intellique.com> wrote:
>
>  dd if=/dev/zero of=/mountpoint/testfile bs=1M count=1024

Keep in mind that the above test tests two subsystems at the same
time: RAID-1 + the filesystem on top of it. If you want to test RAID-1
performance you should specify a raw device to of=... instead of a
file (and the direct I/O flags). There are considerable performance
differences between filesystems for large files. E.g. XFS is a lot
faster than ext3 for large files (gigabytes).

Bart.
