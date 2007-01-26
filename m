Return-Path: <linux-kernel-owner+w=401wt.eu-S1030719AbXAZPGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030719AbXAZPGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030731AbXAZPGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:06:48 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:33296
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030719AbXAZPGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:06:47 -0500
Message-ID: <45BA190C.5040300@microgate.com>
Date: Fri, 26 Jan 2007 09:06:52 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
References: <20070124204009.GA7584@csclub.uwaterloo.ca> <45B7CDB5.7020909@microgate.com> <20070125151639.GH7582@csclub.uwaterloo.ca> <20070126142041.GD7584@csclub.uwaterloo.ca> <45BA1556.8080808@microgate.com> <20070126145608.GK7582@csclub.uwaterloo.ca>
In-Reply-To: <20070126145608.GK7582@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> I am not sure actually.  I just open /dev/ttyn0 and /dev/ttyn1 and write
> to one, and read from the other.  I didn't even know about the line
> diciplines actually.  How do I tell which one I am using?

ioctl(TIOCSETD/TIOCGETD) sets/returns an integer identifier
that can be compared agains the N_XXX macros. If you are
not explicitly setting this then is is probably the default N_TTY.

Also at the application level, look at tcsetattr() for setting
the termios features. Look specifically at the c_cc[VTIME] and c_cc[VMIN]
members of the termios structure. These settings control how
much data must be available before returning data to a read().
Try VTIME=0 and VMIN=1.

Since your 'missing' data is always on the tail end, maybe
VMIN is set to 64 or something.

-- 
Paul Fulghum
Microgate Systems, Ltd.
