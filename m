Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbZFTTUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbZFTTUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 15:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbZFTTU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 15:20:26 -0400
Received: from mail-fx0-f214.google.com ([209.85.220.214]:49319 "EHLO
	mail-fx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZFTTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 15:20:25 -0400
MIME-Version: 1.0
In-Reply-To: <4A3AE162.7040407@gmail.com>
References: <4A38F229.70504@ahsoftware.de> <4A3AE162.7040407@gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 20 Jun 2009 21:20:11 +0200
Message-ID: <ac3eb2510906201220v7fc1d51ve4a9937a3d73d3d4@mail.gmail.com>
Subject: Re: asynchronous calls an the lack of --wait-for-completion options 
	(e.g. modprobe, losetup, cryptsetup)
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 02:52, Robert Hancock<hancockrwd@gmail.com> wrote:
> On 06/17/2009 07:39 AM, Alexander Holler wrote:

>> The problem is that when I'm e.g. calling modprobe loop, loop might not
>> has finished it's initialization, when modprobe returns.
>
> It will have. Just that udev won't have received the events and created the
> device node yet. So the solution would likely be on the udev side..

The brutal method to do this is to call:
  udevadm settle
after loading the module. It will block until all currently pending
events for udev are fully handled.

Recent udevadm versions also have a:
  --exit-if-exists=<filename>
option, which will make "settle" stop waiting if a given file exists.

Kay
