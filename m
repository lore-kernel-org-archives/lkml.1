Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbZAaEbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbZAaEbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 23:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZAaEav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 23:30:51 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:59723 "EHLO
	QMTA10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbZAaEau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 23:30:50 -0500
Date: Fri, 30 Jan 2009 20:29:59 -0800
From: Dmitry Torokhov <dtor@mail.ru>
To: Richard Atterer <atterer@debian.org>
Cc: linux-kernel@vger.kernel.org, vojtech@ucw.cz, linux-input@vger.kernel.org,
       rubini@vision.unipv.it, jkosina@suse.cz
Subject: Re: [PATCH 2.6.28] mousedev: Allow devices to be excluded from
	/dev/input/mice
Message-ID: <20090131042959.GA3529@dtor-d630.eng.vmware.com>
References: <20090130120456.GA20461@arbonne.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130120456.GA20461@arbonne.lan>
X-KMail-Identity: 252080433
X-KMail-Transport: Mailhub
User-Agent: KMail/1.10.4 (Linux/2.6.27.12-170.2.5.fc10.x86_64; KDE/4.1.4;
	x86_64; ; )
X-KMail-Link-Message: 237665
X-KMail-Link-Type: reply
X-KMail-SignatureActionEnabled: false
X-KMail-EncryptActionEnabled: false
X-KMail-CryptoMessageFormat: 15
X-KMail-Recipients: Richard Atterer <atterer@debian.org>,
	linux-kernel@vger.kernel.org, vojtech@ucw.cz,
	linux-input@vger.kernel.org, rubini@ipvvis.unipv.it, jkosina@suse.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Friday 30 January 2009 04:04:56 Richard Atterer wrote:
> From: Richard Atterer <atterer@debian.org>
>
> Allow devices to be excluded from /dev/input/mice
>
> This patch adds an "ignoreid=0x1234:0x5678" parameter to the mousedev
> module. If a mouse matches the given device ID(s), its movement and button
> presses will not be relayed via /dev/input/mice.
>

Thank you for the patch, however I don't think that it is the right solution.

> Why is this needed? In my case, I'm using some mice as sensors (robotic
> application, more or less), so their movement should not influence the
> mouse pointer at all.

I think this is the case where EVIOCGRAB use is warranted then.

> I could simply specify only my main mouse in
> xorg.conf rather than /dev/input/mice. However, /dev/input/mice is the only
> way to allow hot-plugging of mice with X.
>

The newer X does support input hotplug pretty well actually.

> This feature could also be used to disable non-working/buggy touchpads in
> laptops.
>

You can already do that by unbinding serio and usb devices from their 
respective drivers, no need to modify mousedev.

-- 
Dmitry
