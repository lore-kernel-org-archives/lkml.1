Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbZEOGYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbZEOGYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 02:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbZEOGYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 02:24:20 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:53023 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbZEOGYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 02:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=odiEPUVB4zvV89Fbkk0lqskhnhVSqbBcBAc+OfTMv/MLmbGIf+PKxrfdEKYfSvCZ77
         AY3Exm/f8qV3I8NB+1ZM6bJSlDVvYabNRLBkaVu0QW3i+wu3iw5Xct5666JFx/UqwZB1
         QgtUwxIvMrUdP6vuuBisLDFUTQiZ09V3lpows=
Message-ID: <4A0D0A76.7040806@gmail.com>
Date: Fri, 15 May 2009 08:23:50 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b5pre) Gecko/20090511 SUSE/3.0b2-9.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch 29/51] mac80211: pid, fix memory corruption
References: <20090514223235.348540705@mini.kroah.org> <20090514223525.042094922@mini.kroah.org>
In-Reply-To: <20090514223525.042094922@mini.kroah.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

note that you were about to drop this one now because of waiting for a
fixup which is not upstream so far. Did anything change?

(This is the one which fixes a memory corruption, but triggers a bug
causing oopses on single band cards.)

On 05/15/2009 12:33 AM, Greg KH wrote:
From: Jiri Slaby <jirislaby@gmail.com>

commit 6909268dc93ae4b0b8e1ebb4b2fa70b1a47dd347 upstream.

pid doesn't count with some band having more bitrates than the one
associated the first time.
Fix that by counting the maximal available bitrate count and allocate
big enough space.

Secondly, fix touching uninitialized memory which causes panics.
Index sucked from this random memory points to the hell.
The fix is to sort the rates on each band change.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
