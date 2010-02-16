Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab0BPU1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 15:27:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932665Ab0BPU1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 15:27:21 -0500
Date: Tue, 16 Feb 2010 12:26:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: NISHIMOTO Hiroki <tlayboy@gmail.com>
Cc: linux-kernel@vger.kernel.org, ben-linux@fluff.org,
       Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] driver/misc: Add new driver for Avago ADJD-S371-QR999
Message-Id: <20100216122655.9a25e83a.akpm@linux-foundation.org>
In-Reply-To: <1266156496-15269-1-git-send-email-tlayboy@gmail.com>
References: <1266156496-15269-1-git-send-email-tlayboy@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Feb 2010 23:08:16 +0900
NISHIMOTO Hiroki <tlayboy@gmail.com> wrote:

> Add new driver for Avago ADJD-S371-QR999 digital color sensor.
> 
> This driver has two functions.
> 1. raw_color
>        Gets color values of object.
> 2. trim_color
>        Gets color values of object except the influence of natural light.
> 
> Reset, sleep, external clock functions are not mandatory, so not implemented.
> 

There are quite a number of driver commands here which weren't
documented.  Please fully describe the proposed userspace interface
within the changelog.  Or, better, within a documentation file. 
Because the userspace interface is the most important part.  It's the
only thing we can never change.

It appears that the entire userspace interface for this driver is
implemented via sysfs?  This is odd - we used to have this thing called
"/dev" for communicating with device drivers.  What do people think
about this?

The proposed sysfs interface appears to emit multiple values from a
single sysfs file.  This is considered to be against the sysfs design
rules.

Note that all the above discusses the usersapce interface!  Once we get
that sorted out then we can start looking at the implementation.

