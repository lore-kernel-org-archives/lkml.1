Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbYFDRmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbYFDRmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbYFDRm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:42:29 -0400
Received: from sous-sol.org ([216.99.217.87]:51154 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbYFDRm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:42:28 -0400
Date: Wed, 4 Jun 2008 10:40:02 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Steven French <sfrench@us.ibm.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: primitive is not an asn1 class
Message-ID: <20080604174002.GY30402@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When verifying the decoded header before decoding the object identifier
(expecting a SPNEGO pseudo-mechanism oid), the test to verify it is a
primitive encoding is compared against the asn1 class.  Primitive is not a
class.  This brings check in line with similar check for krb/ntlmssp oid.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/cifs/asn1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index cb52cbb..49be2ed 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -480,7 +480,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 		/*      remember to free obj->oid */
 		rc = asn1_header_decode(&ctx, &end, &cls, &con, &tag);
 		if (rc) {
-			if ((tag == ASN1_OJI) && (cls == ASN1_PRI)) {
+			if ((tag == ASN1_OJI) && (con == ASN1_PRI)) {
 				rc = asn1_oid_decode(&ctx, end, &oid, &oidlen);
 				if (rc) {
 					rc = compare_oid(oid, oidlen,
