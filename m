Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYHEOOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYHEOOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 10:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbYHEON6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 10:13:58 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:6967 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYHEON5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 10:13:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=gm5KnHQvdaEJdGanhv98ZNDP9VlAHtPfv/DtOwVAQJ5veopkpCKGqA2WQ3zBAW4UvY
         /x6IHMQ8thh0toRvwavOAWyhjGGuWSjx4mS1AtFmmmC2U83+5WS5Px/apq2/AjeFAg4K
         2tggmtUgw4DtPfupdfX3IKcKAvOhbDznE8l8E=
Message-ID: <87a5b0800808050713y520bdc00t7a48aa46473bae44@mail.gmail.com>
Date: Tue, 5 Aug 2008 15:13:55 +0100
From: "Will Newton" <will.newton@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] 8250: Remove a few inlines of dubious value.
Cc: linux-serial <linux-serial@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5086_25585491.1217945635982"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5086_25585491.1217945635982
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch removes some inlines from various functions that are called once,
are too big to inline, or are called only from slow path code. This saves
around 300 bytes of code for me.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/serial/8250.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 342e12f..153e3c1 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -536,7 +536,7 @@ static unsigned int serial_icr_read(struct
uart_8250_port *up, int offset)
 /*
  * FIFO support.
  */
-static inline void serial8250_clear_fifos(struct uart_8250_port *p)
+static void serial8250_clear_fifos(struct uart_8250_port *p)
 {
 	if (p->capabilities & UART_CAP_FIFO) {
 		serial_outp(p, UART_FCR, UART_FCR_ENABLE_FIFO);
@@ -551,7 +551,7 @@ static inline void serial8250_clear_fifos(struct
uart_8250_port *p)
  * capability" bit enabled.  Note that on XR16C850s, we need to
  * reset LCR to write to IER.
  */
-static inline void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
+static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 {
 	if (p->capabilities & UART_CAP_SLEEP) {
 		if (p->capabilities & UART_CAP_EFR) {
@@ -1424,8 +1424,7 @@ static unsigned int check_modem_status(struct
uart_8250_port *up)
 /*
  * This handles the interrupt from one port.
  */
-static inline void
-serial8250_handle_port(struct uart_8250_port *up)
+static void serial8250_handle_port(struct uart_8250_port *up)
 {
 	unsigned int status;
 	unsigned long flags;
@@ -1719,7 +1718,7 @@ static void serial8250_break_ctl(struct
uart_port *port, int break_state)
 /*
  *	Wait for transmitter & holding register to empty
  */
-static inline void wait_for_xmitr(struct uart_8250_port *up, int bits)
+static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 {
 	unsigned int status, tmout = 10000;

-- 
1.5.5.2

------=_Part_5086_25585491.1217945635982
Content-Type: text/x-patch;
 name=0001-8250-Remove-a-few-inlines-of-dubious-value.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjilc7cg0
Content-Disposition: attachment;
 filename=0001-8250-Remove-a-few-inlines-of-dubious-value.patch

RnJvbSA1MWUwYjM4ZTY1MzQwMjRlODY3MmIzMDhjYTAzZGQ2MmQzZmUxZWZiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBUdWUsIDUgQXVnIDIwMDggMTU6MDY6MjQgKzAxMDAKU3ViamVjdDogW1BBVENIXSA4MjUw
OiBSZW1vdmUgYSBmZXcgaW5saW5lcyBvZiBkdWJpb3VzIHZhbHVlLgoKVGhpcyBwYXRjaCByZW1v
dmVzIHNvbWUgaW5saW5lcyBmcm9tIHZhcmlvdXMgZnVuY3Rpb25zIHRoYXQgYXJlIGNhbGxlZCBv
bmNlLAphcmUgdG9vIGJpZyB0byBpbmxpbmUsIG9yIGFyZSBjYWxsZWQgb25seSBmcm9tIHNsb3cg
cGF0aCBjb2RlLiBUaGlzIHNhdmVzCmFyb3VuZCAzMDAgYnl0ZXMgb2YgY29kZSBmb3IgbWUuCgpT
aWduZWQtb2ZmLWJ5OiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgotLS0KIGRy
aXZlcnMvc2VyaWFsLzgyNTAuYyB8ICAgIDkgKysrKy0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDQg
aW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Nlcmlh
bC84MjUwLmMgYi9kcml2ZXJzL3NlcmlhbC84MjUwLmMKaW5kZXggMzQyZTEyZi4uMTUzZTNjMSAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zZXJpYWwvODI1MC5jCisrKyBiL2RyaXZlcnMvc2VyaWFsLzgy
NTAuYwpAQCAtNTM2LDcgKzUzNiw3IEBAIHN0YXRpYyB1bnNpZ25lZCBpbnQgc2VyaWFsX2ljcl9y
ZWFkKHN0cnVjdCB1YXJ0XzgyNTBfcG9ydCAqdXAsIGludCBvZmZzZXQpCiAvKgogICogRklGTyBz
dXBwb3J0LgogICovCi1zdGF0aWMgaW5saW5lIHZvaWQgc2VyaWFsODI1MF9jbGVhcl9maWZvcyhz
dHJ1Y3QgdWFydF84MjUwX3BvcnQgKnApCitzdGF0aWMgdm9pZCBzZXJpYWw4MjUwX2NsZWFyX2Zp
Zm9zKHN0cnVjdCB1YXJ0XzgyNTBfcG9ydCAqcCkKIHsKIAlpZiAocC0+Y2FwYWJpbGl0aWVzICYg
VUFSVF9DQVBfRklGTykgewogCQlzZXJpYWxfb3V0cChwLCBVQVJUX0ZDUiwgVUFSVF9GQ1JfRU5B
QkxFX0ZJRk8pOwpAQCAtNTUxLDcgKzU1MSw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBzZXJpYWw4
MjUwX2NsZWFyX2ZpZm9zKHN0cnVjdCB1YXJ0XzgyNTBfcG9ydCAqcCkKICAqIGNhcGFiaWxpdHki
IGJpdCBlbmFibGVkLiAgTm90ZSB0aGF0IG9uIFhSMTZDODUwcywgd2UgbmVlZCB0bwogICogcmVz
ZXQgTENSIHRvIHdyaXRlIHRvIElFUi4KICAqLwotc3RhdGljIGlubGluZSB2b2lkIHNlcmlhbDgy
NTBfc2V0X3NsZWVwKHN0cnVjdCB1YXJ0XzgyNTBfcG9ydCAqcCwgaW50IHNsZWVwKQorc3RhdGlj
IHZvaWQgc2VyaWFsODI1MF9zZXRfc2xlZXAoc3RydWN0IHVhcnRfODI1MF9wb3J0ICpwLCBpbnQg
c2xlZXApCiB7CiAJaWYgKHAtPmNhcGFiaWxpdGllcyAmIFVBUlRfQ0FQX1NMRUVQKSB7CiAJCWlm
IChwLT5jYXBhYmlsaXRpZXMgJiBVQVJUX0NBUF9FRlIpIHsKQEAgLTE0MjQsOCArMTQyNCw3IEBA
IHN0YXRpYyB1bnNpZ25lZCBpbnQgY2hlY2tfbW9kZW1fc3RhdHVzKHN0cnVjdCB1YXJ0XzgyNTBf
cG9ydCAqdXApCiAvKgogICogVGhpcyBoYW5kbGVzIHRoZSBpbnRlcnJ1cHQgZnJvbSBvbmUgcG9y
dC4KICAqLwotc3RhdGljIGlubGluZSB2b2lkCi1zZXJpYWw4MjUwX2hhbmRsZV9wb3J0KHN0cnVj
dCB1YXJ0XzgyNTBfcG9ydCAqdXApCitzdGF0aWMgdm9pZCBzZXJpYWw4MjUwX2hhbmRsZV9wb3J0
KHN0cnVjdCB1YXJ0XzgyNTBfcG9ydCAqdXApCiB7CiAJdW5zaWduZWQgaW50IHN0YXR1czsKIAl1
bnNpZ25lZCBsb25nIGZsYWdzOwpAQCAtMTcxOSw3ICsxNzE4LDcgQEAgc3RhdGljIHZvaWQgc2Vy
aWFsODI1MF9icmVha19jdGwoc3RydWN0IHVhcnRfcG9ydCAqcG9ydCwgaW50IGJyZWFrX3N0YXRl
KQogLyoKICAqCVdhaXQgZm9yIHRyYW5zbWl0dGVyICYgaG9sZGluZyByZWdpc3RlciB0byBlbXB0
eQogICovCi1zdGF0aWMgaW5saW5lIHZvaWQgd2FpdF9mb3JfeG1pdHIoc3RydWN0IHVhcnRfODI1
MF9wb3J0ICp1cCwgaW50IGJpdHMpCitzdGF0aWMgdm9pZCB3YWl0X2Zvcl94bWl0cihzdHJ1Y3Qg
dWFydF84MjUwX3BvcnQgKnVwLCBpbnQgYml0cykKIHsKIAl1bnNpZ25lZCBpbnQgc3RhdHVzLCB0
bW91dCA9IDEwMDAwOwogCi0tIAoxLjUuNS4yCgo=
------=_Part_5086_25585491.1217945635982--
