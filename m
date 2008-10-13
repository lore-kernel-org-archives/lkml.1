Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYJMVIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYJMVIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755342AbYJMVHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:07:51 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbYJMVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:07:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=DUw7sHWe4kvn1XvWtR+miBTd69QxU+B5cLjzFLEeZSf0VKLHDhVfIP0mHkpJjSNCR
	WOujiw3c0VYzU18X7a4Hw==
Message-ID: <da824cf30810131407m1a73bd11xa30fd118ee5a4c8f@mail.gmail.com>
Date: Mon, 13 Oct 2008 14:07:15 -0700
From: "Grant Grundler" <grundler@google.com>
To: "kenneth johansson" <ken@kenjo.org>
Subject: Re: weird throughput on write to SATA disk
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1223925629.3947.7.camel@duo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223925629.3947.7.camel@duo>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 12:19 PM, kenneth johansson <ken@kenjo.org> wrote:
> When writing data to /dev/sdb (that is the whole disk and no filesystem)
> it starts out ok around 100MB/sec but soon end up doing considerably
> worse. For prolonged times lasting several minutes it hovers in the
> 20-30MB/sec.

Is the application using "O_DIRECT"?
If not, could be issue with how VM writeback is (not) working.

Can you reproduce this using fio or even "dd"?
(See git://git.kernel.dk/fio)

grant

>
> This happens on two different SATA disk one samsung and one seagate and
> on both 2.6.26 and 2.6.27 kernel. The disk are connected to the external
> esata connector. Controller is 00:1f.2 SATA controller: Intel
> Corporation 82801HB (ICH8) 4 port SATA AHCI Controller (rev 02)
>
> What could be the reason for this ?? reading is no problem.
>
>
>
