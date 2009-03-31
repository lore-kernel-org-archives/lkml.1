Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbZCaTZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbZCaTZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZCaTYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:24:54 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:56106 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188AbZCaTYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:24:53 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net B52772C2C86
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Sysfs with no struc device ?
To: Ayman KHAMOUMA <ayman.khamouma@st.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Tue, 31 Mar 2009 21:24:49 +0200
References: <clPat-8uW-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LojZq-0001MG-AM@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ayman KHAMOUMA <ayman.khamouma@st.com> wrote:

> I'm trying to write a module which is supposed to write the state of a pin in
> a sysfs file. As it is neither a char device nor a block device, or anything
> else, I suposed taht I don't need any struct device...I mau be mistaking... So
> my question is: How can I create this file in sysfs without any struct device
> ?

Why don't you create a char device: Reader will get one char per status change
(and one initial char, off cause), while mmap will map the flag? You'd get
the interface you want (except the path beginning with /sys), and more.

Or, if you wanted a more sophisticated way, you could use a one-button-zero-axis
joystick device, very similar to the parport joystick. But I doubt it would make
sense for your usecase?

