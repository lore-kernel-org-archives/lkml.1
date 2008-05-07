Return-Path: <linux-kernel-owner+w=401wt.eu-S1762724AbYEGHpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762724AbYEGHpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932718AbYEGHo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:44:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:60924 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700AbYEGHo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PVYmpv1OCuhcq6n0iLQcDgTmp2ghGwyxDnAmC4G/8WPe/UXwbEzL1UgA63WBMdVHTBLg70DeiXZCalCklP5by4B6KrLF8q395w7Ny83+cajC2huyCgIprGvfNIPtJHYXDs6Y1HPyQyrwXzZizsT5nfAbX/QzYT+V8Htr2at3TDk=
Message-ID: <e2e108260805070044v42f596bbj39c5b52b6f0a096@mail.gmail.com>
Date: Wed, 7 May 2008 09:44:54 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Tomasz Chmielewski" <mangoo@wpkg.org>
Subject: Re: Compact Flash Question
Cc: LKML <linux-kernel@vger.kernel.org>, YSadgat1@gcte.com,
       linux-os@analogic.com, Alan <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <48215673.3060201@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48215673.3060201@wpkg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 9:12 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> As Compact Flash and its wear levelling does not know about free space on
> the filesystem, the wear levelling's effectiveness can be only limited -
> writes won't spread on the whole free area of the flash.
>
> Does anyone know how wear levelling is done in these devices? Perhaps it
> will differ from a manufacturer to manufacturer, but I guess they have a
> free area we normally use to store data, and some reserved area used just
> for wear levelling and bad block handling, but that's just my guess.

The wear leveling algorithm depends on the CompactFlash manufacturer.
Most manufacturers define a certain number of areas on a CompactFlash.
Each area consists of two or more sectors which are counted in the
total size of the CompactFlash, and one or more spare sectors. Wear
leveling is carried out within an area by spreading writes over the
sectors in an area. The controller in the CompactFlash stores the data
about which sectors are used for storing which data persistently. I
know of only one manufacturer who makes the CompactFlash controllers
carry out wear leveling over the whole CompactFlash. Some CompactFlash
devices even allow to query statistics about the wear leveling
algorithm history.

> noatime implies nodiratime, so there is no need to add the latter.

Thanks for the info.

Bart.
