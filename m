Return-Path: <linux-kernel-owner+w=401wt.eu-S1764841AbZBNBlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764841AbZBNBlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762003AbZBNBQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:39 -0500
Received: from kroah.org ([198.145.64.141]:50550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762599AbZBNBQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:30 -0500
Date: Fri, 13 Feb 2009 17:13:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 33/48] tun: Add some missing TUN compat ioctl translations.
Message-ID: <20090214011324.GG17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="tun-add-some-missing-tun-compat-ioctl-translations.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit df1c46b2b6876d0a1b1b4740f009fa69d95ebbc9 ]

Based upon a report from Michael Tokarev <mjt@tls.msk.ru>:

	Just saw in dmesg:

	ioctl32(kvm:4408): Unknown cmd fd(9) cmd(800454cf){t:'T';sz:4} arg(ffc668e4) on /dev/net/tun

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat_ioctl.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -538,6 +538,7 @@ static int dev_ifsioc(unsigned int fd, u
 		 * cannot be fixed without breaking all existing apps.
 		 */
 		case TUNSETIFF:
+		case TUNGETIFF:
 		case SIOCGIFFLAGS:
 		case SIOCGIFMETRIC:
 		case SIOCGIFMTU:
@@ -1982,6 +1983,11 @@ COMPATIBLE_IOCTL(TUNSETNOCSUM)
 COMPATIBLE_IOCTL(TUNSETDEBUG)
 COMPATIBLE_IOCTL(TUNSETPERSIST)
 COMPATIBLE_IOCTL(TUNSETOWNER)
+COMPATIBLE_IOCTL(TUNSETLINK)
+COMPATIBLE_IOCTL(TUNSETGROUP)
+COMPATIBLE_IOCTL(TUNGETFEATURES)
+COMPATIBLE_IOCTL(TUNSETOFFLOAD)
+COMPATIBLE_IOCTL(TUNSETTXFILTER)
 /* Big V */
 COMPATIBLE_IOCTL(VT_SETMODE)
 COMPATIBLE_IOCTL(VT_GETMODE)
@@ -2573,6 +2579,7 @@ HANDLE_IOCTL(SIOCGIFPFLAGS, dev_ifsioc)
 HANDLE_IOCTL(SIOCGIFTXQLEN, dev_ifsioc)
 HANDLE_IOCTL(SIOCSIFTXQLEN, dev_ifsioc)
 HANDLE_IOCTL(TUNSETIFF, dev_ifsioc)
+HANDLE_IOCTL(TUNGETIFF, dev_ifsioc)
 HANDLE_IOCTL(SIOCETHTOOL, ethtool_ioctl)
 HANDLE_IOCTL(SIOCBONDENSLAVE, bond_ioctl)
 HANDLE_IOCTL(SIOCBONDRELEASE, bond_ioctl)

