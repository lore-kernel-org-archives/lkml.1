Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbYIEXsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbYIEXsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYIEXr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:47:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:2365 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbYIEXr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:47:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,342,1217833200"; 
   d="scan'208";a="436248632"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C90FB1.D2462C31"
Subject: RE: [E1000-devel] linux-next: Tree for September 4 (PATCH: IXGBE)
Date: Fri, 5 Sep 2008 16:47:55 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F5206120576@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20080904204137.9b31f644.randy.dunlap@oracle.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [E1000-devel] linux-next: Tree for September 4 (PATCH: IXGBE)
Thread-Index: AckPCWaCnsXb0uofQpqaw9lW4ZPiEgAouCLw
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au> <20080904204137.9b31f644.randy.dunlap@oracle.com>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "jgarzik" <jgarzik@pobox.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       <e1000-devel@lists.sourceforge.net>
Cc: "Morton" <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       <Andrew@sc8-sf-spam2-b.sourceforge.net>
X-OriginalArrivalTime: 05 Sep 2008 23:47:56.0829 (UTC) FILETIME=[D2475CD0:01C90FB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C90FB1.D2462C31
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> ixgbe needs to be restricted to the same build config (m/y)
> as DCA since it calls the dca_*() functions.
>=20
> ixgbe_main.c:(.text+0xd9c09): undefined reference to `dca3_get_tag'
> ixgbe_main.c:(.text+0xd9cc9): undefined reference to `dca3_get_tag'
> ixgbe_main.c:(.text+0xda5c1): undefined reference to
> `dca_add_requester' ixgbe_main.c:(.text+0xda5d6): undefined reference
> to `dca_remove_requester' text+0xdc162): undefined reference to
> `dca_add_requester'=20
> text+0xdc1d3): undefined reference to `dca_remove_requester'
> ixgbe_main.c:(.init.text+0xa74b): undefined reference to
> `dca_register_notify' ixgbe_main.c:(.devinit.text+0xa4ca): undefined
> reference to `dca_add_requester' ixgbe_main.c:(.exit.text+0xd21):
> undefined reference to `dca_unregister_notify'
> ixgbe_main.c:(.devexit.text+0x72d): undefined reference to
> `dca_remove_requester' make[1]: *** [.tmp_vmlinux1] Error 1=20
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
...
> +	depends on PCI && INET && DCA

Looks like you set IXGBE=3Dy and CONFIG_DCA=3Dm.  This depends DCA =
option is
not so great because if INTEL_IOATDMA is disabled (and therefore DCA is
disabled) then ixgbe won't show up as an option.

How about this instead, use a select INTEL_IOATDMA:

inline is whitespace busted, sorry. attached is the patch.


------_=_NextPart_001_01C90FB1.D2462C31
Content-Type: application/octet-stream;
	name="ixgbe_Kconfig_dca.patch"
Content-Transfer-Encoding: base64
Content-Description: ixgbe_Kconfig_dca.patch
Content-Disposition: attachment;
	filename="ixgbe_Kconfig_dca.patch"

aXhnYmU6IGZpeCBEQ0EgZGVwZW5kZW5jeSBpbiBLY29uZmlnCgpGcm9tOiBKZXNzZSBCcmFuZGVi
dXJnIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT4KCml4Z2JlIGNhbiBkZXBlbmQgb24gZGNh
IElGIGl0IGlzIGVuYWJsZWQuICBTbyBpZiB3ZSBhcmUgY29tcGlsZWQKYXMgSVhHQkU9eSwgYW5k
IERDQSBpcyBlbmFibGVkLCB0aGVuIHdlIG11c3QgZm9yY2UgSU5URUxfSU9BVERNQQphbmQgdGhl
cmVmb3JlIERDQSB0byBiZSA9eSBhbHNvLgoKU2lnbmVkLW9mZi1ieTogSmVzc2UgQnJhbmRlYnVy
ZyA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+CkNDOiBSYW5keSBEdW5sYXAgPHJhbmR5LmR1
bmxhcEBvcmFjbGUuY29tPgpDQzogRW1pbCBUYW50aWxvdiA8ZW1pbC5zLnRhbnRpbG92QGludGVs
LmNvbT4KLS0tCiBkcml2ZXJzL25ldC9LY29uZmlnIHwgICAgMSArCiAxIGZpbGVzIGNoYW5nZWQs
IDEgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9LY29uZmlnIGIvZHJpdmVycy9uZXQvS2NvbmZpZwppbmRleCA0YTExMjk2Li44NmY1M2ExIDEw
MDY0NAotLS0gYS9kcml2ZXJzL25ldC9LY29uZmlnCisrKyBiL2RyaXZlcnMvbmV0L0tjb25maWcK
QEAgLTIzODEsNiArMjM4MSw3IEBAIGNvbmZpZyBJWEdCRQogCXRyaXN0YXRlICJJbnRlbChSKSAx
MEdiRSBQQ0kgRXhwcmVzcyBhZGFwdGVycyBzdXBwb3J0IgogCWRlcGVuZHMgb24gUENJICYmIElO
RVQKIAlzZWxlY3QgSU5FVF9MUk8KKwlzZWxlY3QgSU5URUxfSU9BVERNQQogCS0tLWhlbHAtLS0K
IAkgIFRoaXMgZHJpdmVyIHN1cHBvcnRzIEludGVsKFIpIDEwR2JFIFBDSSBFeHByZXNzIGZhbWls
eSBvZgogCSAgYWRhcHRlcnMuICBGb3IgbW9yZSBpbmZvcm1hdGlvbiBvbiBob3cgdG8gaWRlbnRp
ZnkgeW91ciBhZGFwdGVyLCBnbwo=

------_=_NextPart_001_01C90FB1.D2462C31--
