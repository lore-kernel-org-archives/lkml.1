Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbYDQHMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbYDQHMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 03:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbYDQHMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 03:12:25 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:59205 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbYDQHMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 03:12:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=gkXAmK4868QhN3VxgF2gvn0l0pX5iWQMGoO3GixKQMfpRRbQ436JfxjEed2PpQqGDgnqN2S6iu50dezaje+/EDhh41ciqYjMLfuirxBVYYcL/4ggbt8FWt/tRZ5yvvDw8/dj/C9HVNdLBUsMVYh3YMxsmjM70obazhq4Sij9+Ms=
Message-ID: <b25312890804170012p50a1d95akd198569fcc01ddf@mail.gmail.com>
Date: Thu, 17 Apr 2008 10:12:22 +0300
From: "Rami Rosen" <roszenrami@gmail.com>
To: yoshfuji@linux-ipv6.org
Subject: [PATCH] [mcast-tools] Enable build of pim6sd when glibc is higher than 2.3.x
Cc: johnsonzjo@gmail.com, netdev@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2271_8666857.1208416342441"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_2271_8666857.1208416342441
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This patch enables building pim6sd successfully on machines where
glibc is higher than 2.3.x
in the mcast mcast-tools git tree (both for i386 and x86_64 machines).

Running next series of opetaions will succeed now:
git-clone git://git.linux-ipv6.org/gitroot/yoshfuji/mcast-tools.git
cd mcast-tools
aclocal; automake; autoconf
./configure
cd pim6sd
make


Regards,
Rami Rosen


Signed-off-by: Rami Rosen  <roszenrami@gmail.com>



On Tue, Apr 8, 2008 at 12:14 PM, David Miller <davem@davemloft.net> wrote:
> From: "Andy Johnson" <johnsonzjo@gmail.com>
>  Date: Tue, 8 Apr 2008 09:57:39 +0300
>
>
>  > mld6.c: In function 'init_mld6':
>  > mld6.c:210: error: 'ICMP6_MEMBERSHIP_QUERY' undeclared (first use in
>  > this function)
>  > mld6.c:210: error: (Each undeclared identifier is reported only once
>  > mld6.c:210: error: for each function it appears in.)
>  > mld6.c:211: error: 'ICMP6_MEMBERSHIP_REPORT' undeclared (first use in
>  > this function)
>  > mld6.c:212: error: 'ICMP6_MEMBERSHIP_REDUCTION' undeclared (first use
>  > in this function)
>  > mld6.c: In function 'accept_mld6':
>  > mld6.c:451: error: 'MLD_LISTENER_DONE' undeclared (first use in this function)
>
>  Somewhere along the line ICMP6_MEMBERSHIP_* got changed
>  into MLD_LISTENER_* in the glibc headers.
>
>  Similarly MLD_LISTENER_DONE should be MLD_LISTENER_REDUCTION.
>
>  In glibc-2.3.x both defines were provided, but after that the old
>  ICMP6_* defines were completely removed.
>
>  Probably Yoshifuji-san tests the user tool builds on a glibc-2.3.x or
>  earlier system, which has the old deprecated defines.
>
>  So if you simply change:
>
>         ICMP6_MEMBERSHIP_* --> MLD_LISTENER_*
>
>  and also:
>
>         MLD_LISTENER_DONE --> MLD_LISTENER_REDUCTION
>
>  the build will complete successfully.
>
>
> --
>  To unsubscribe from this list: send the line "unsubscribe netdev" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

------=_Part_2271_8666857.1208416342441
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ff4zf6430
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL3BpbTZzZC9tbGQ2LmggYi9waW02c2QvbWxkNi5oCmluZGV4IDBmMjU0YTAu
LjJmNDFiMjkgMTAwNjQ0Ci0tLSBhL3BpbTZzZC9tbGQ2LmgKKysrIGIvcGltNnNkL21sZDYuaApA
QCAtOTgsNiArOTgsMTggQEAgc3RydWN0IG1sZF9oZHIgewogI2RlZmluZSBtbGRfcmVzZXJ2ZWQJ
bWxkNl9yZXNlcnZlZAogI2VuZGlmCiAKKy8qIEZvciBnbGliYyBoaWdoZXIgdGhhbiAyLjMueCAq
LworI2lmbmRlZiBJQ01QNl9NRU1CRVJTSElQX1FVRVJZCisjZGVmaW5lIElDTVA2X01FTUJFUlNI
SVBfUVVFUlkgICAgIE1MRF9MSVNURU5FUl9RVUVSWQorI2RlZmluZSBJQ01QNl9NRU1CRVJTSElQ
X1JFRFVDVElPTiBNTERfTElTVEVORVJfUkVEVUNUSU9OCisjZGVmaW5lIElDTVA2X01FTUJFUlNI
SVBfUkVQT1JUICAgIE1MRF9MSVNURU5FUl9SRVBPUlQKKyNkZWZpbmUgTUxEX0xJU1RFTkVSX0RP
TkUgICAgICAgICAgTUxEX0xJU1RFTkVSX1JFRFVDVElPTgorI2RlZmluZSBNTERfTVRSQUNFX1JF
U1AgICAgICAgICAgICAyMDEKKyNkZWZpbmUgTUxEX01UUkFDRSAgICAgICAgICAgICAgICAgMjAy
CisKKyNlbmRpZgorCisKICNpZm5kZWYgSVA2T1BUX1JUQUxFUlRfTUxECiAjZGVmaW5lIElQNk9Q
VF9SVEFMRVJUX01MRAkwCiAjZGVmaW5lIElQNk9QVF9SVEFMRVJUCQkweDA1Cg==
------=_Part_2271_8666857.1208416342441--
