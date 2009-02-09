Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbZBIVGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbZBIVGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZBIVGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:06:25 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:54006 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZBIVGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:06:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=naq+j5wvWJnFrA08aPmA4q7/ihlQZJvkRZpnFoPgcq/M64rgqJ8BLhhmYgKNyK0bgi
         WMbfj8DXnUtieTU+e44GOUo1cI9StHGh/rH/jcL4T0mVanFcFzm0GSUSSOLGH/4pYWKh
         IdpM/h1tc+fJboySXCZx6ULKLjehKx5zuIk8o=
MIME-Version: 1.0
In-Reply-To: <20090209190142.GD19453@n2100.arm.linux.org.uk>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com>
	 <20090209171042.GA19453@n2100.arm.linux.org.uk>
	 <8447d6730902090944s9bc96f7r76da82ea09c629f0@mail.gmail.com>
	 <20090209175514.GB19453@n2100.arm.linux.org.uk>
	 <8447d6730902091017m21cb30d0w6be6fbbbf33db4f3@mail.gmail.com>
	 <8447d6730902091054x7c4c842m7339382e19260bd8@mail.gmail.com>
	 <20090209190142.GD19453@n2100.arm.linux.org.uk>
Date: Mon, 9 Feb 2009 22:06:23 +0100
Message-ID: <8447d6730902091306ka260b1fi405dd7c17bb2b5d4@mail.gmail.com>
Subject: Re: [PATCH 1/2] User access to internal clocks
From: Davide Rizzo <elpa.rizzo@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, ben-linux@fluff.org,
       linux-api@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What about adding a dedicated function to clk api that registers a struct clk
 in a linked list and associates it with a name, with the only specific purpose
 to enumerate and list (and possibly change rate and parents) all
clocks in sysfs ?
Obviously only specifically registered clocks will be visible in sysfs...

Or better, only proposed functions:
int clk_for_each(int(*fn)(struct clk *, void *), void *data)
and
const char *clk_sysname(struct clk *)
need to be added to clk api, the function to register the struct clk
in the linked list could be implementation specific.
Maybe a function like this:
struct clk *clk_get_by_sysname(const char *sysname);
could be useful to be added to api interface, too ?
