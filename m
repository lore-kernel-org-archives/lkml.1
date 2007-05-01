Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbXEAPRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbXEAPRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbXEAPRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:17:17 -0400
Received: from astra.telenet-ops.be ([195.130.132.58]:60285 "EHLO
	astra.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754AbXEAPRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:17:16 -0400
Date: Tue, 1 May 2007 17:17:13 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: AF_RXRPC depends on KEYS?
Message-ID: <Pine.LNX.4.64.0705011709320.3055@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


| linux/net/rxrpc/af_rxrpc.c: In function 'rxrpc_kernel_begin_call':
| linux/net/rxrpc/af_rxrpc.c:303: error: dereferencing pointer to incomplete type
| linux/net/rxrpc/af_rxrpc.c: In function 'af_rxrpc_init':
| linux/net/rxrpc/af_rxrpc.c:820: warning: implicit declaration of function 'register_key_type'
| linux/net/rxrpc/af_rxrpc.c:839: warning: implicit declaration of function 'unregister_key_type'

Should AF_RXRPC depend on KEYS?

Hmm, I see a few more related things:

| linux/net/rxrpc/ar-key.c:36: error: variable 'key_type_rxrpc' has initializer but incomplete type
| linux/net/rxrpc/ar-key.c:37: error: unknown field 'name' specified in initializer
| linux/net/rxrpc/ar-key.c:37: warning: excess elements in struct initializer
| linux/net/rxrpc/ar-key.c:37: warning: (near initialization for 'key_type_rxrpc')
| linux/net/rxrpc/ar-key.c:38: error: unknown field 'instantiate' specified in initializer
| ...

and

| linux/net/rxrpc/ar-output.c: In function 'rxrpc_client_sendmsg':
| linux/net/rxrpc/ar-output.c:158: error: dereferencing pointer to incomplete type

and

| linux/net/rxrpc/ar-security.c: In function 'rxrpc_init_client_conn_security':
| linux/net/rxrpc/ar-security.c:138: error: dereferencing pointer to incomplete type/home/geert.nba/linux/linux-m68k-2.6.22-rc1/net/rxrpc/ar-security.c: In function 'rxrpc_init_server_conn_security':
| linux/net/rxrpc/ar-security.c:163: error: 'key_ref_t' undeclared (first use in this function)
| ...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
