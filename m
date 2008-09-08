Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYIHSTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYIHSTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYIHSTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:19:38 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:48067 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbYIHSTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:19:37 -0400
Date: Mon, 8 Sep 2008 20:19:23 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: New distributed storage release.
In-Reply-To: <20080908174324.GA18400@2ka.mipt.ru>
Message-ID: <alpine.LNX.2.00.0809081948450.19109@titan.stealer.net>
References: <20080908152201.GA14015@2ka.mipt.ru> <alpine.LNX.2.00.0809081818001.19109@titan.stealer.net> <20080908174324.GA18400@2ka.mipt.ru>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.6
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Mon, 08 Sep 2008 18:19:35 +0000
	Bayes: 0.1720 Tokens: new, 396; hammy, 9; neutral, 8; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1720]
X-Spam-Signature: e6036ac7f9a0b2e0c6ca07f1cb04cc0c32b25944
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, Evgeniy Polyakov wrote:

> Hi Sven.
> 
> Thanks for the review.
> 
> On Mon, Sep 08, 2008 at 07:19:49PM +0200, Sven Wegener (sven.wegener@stealer.net) wrote:
> > Some warnings:
> > 
> >   CC [M]  drivers/block/dst/state.o
> > drivers/block/dst/state.c: In function 'dst_recv_bio':
> > drivers/block/dst/state.c:396: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'sector_t'
> > drivers/block/dst/state.c: In function 'dst_process_io_response':
> > drivers/block/dst/state.c:434: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'sector_t'
> >   CC [M]  drivers/block/dst/export.o
> > drivers/block/dst/export.c: In function 'dst_accept':
> > drivers/block/dst/export.c:249: warning: 'main' is usually a function
> > drivers/block/dst/export.c: In function 'dst_export_read_request':
> > drivers/block/dst/export.c:405: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'sector_t'
> > drivers/block/dst/export.c: In function 'dst_process_io':
> > drivers/block/dst/export.c:520: warning: format '%llu' expects type 'long long unsigned int', but argument 3 has type 'sector_t'
> > drivers/block/dst/export.c: In function 'dst_export_send_bio':
> > drivers/block/dst/export.c:541: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type 'sector_t'
> >   CC [M]  drivers/block/dst/crypto.o
> > drivers/block/dst/crypto.c: In function 'dst_export_crypto_action':
> > drivers/block/dst/crypto.c:623: warning: format '%llu' expects type 'long long unsigned int', but argument 5 has type 'sector_t'
> >   CC [M]  drivers/block/dst/trans.o
> > drivers/block/dst/trans.c: In function 'dst_trans_insert':
> > drivers/block/dst/trans.c:87: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type 'sector_t'
> > drivers/block/dst/trans.c:87: warning: format '%llu' expects type 'long long unsigned int', but argument 8 has type 'sector_t'
> > drivers/block/dst/trans.c:95: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type 'sector_t'
> > drivers/block/dst/trans.c: In function 'dst_process_bio':
> > drivers/block/dst/trans.c:160: warning: format '%llu' expects type 'long long unsigned int', but argument 4 has type 'sector_t'
> 
> Yup, sector_t is diffrent depending on arch and config options (u64 vs unsigned long),
> so it is not possible to represent it correctly without dereferencing
> to another type.

Yup, cast it. That are a lot of warnings and best to avoid them.

> > > diff --git a/drivers/block/dst/Kconfig b/drivers/block/dst/Kconfig
> > > new file mode 100644
> > > index 0000000..0b641f0
> > > --- /dev/null
> > > +++ b/drivers/block/dst/Kconfig
> > > @@ -0,0 +1,18 @@
> > > +menuconfig DST
> > 
> > uhm, menuconfig, and then just the debug option there seems wrong.
> 
> In case of extended functionality there will be no need to change config
> options, now it looks like single string in the higher layer config.

If there is coming more funtionality, ok, but currently it's irritating to 
have a submenu and then just a single debug option in there.

> > > +	ctl->crypto_attached_size = crypto_hash_digestsize(hash);
> > > +
> > > +	dprintk("%s: keysize: %u, key: ", __func__, ctl->hash_keysize);
> > > +	for (err = 0; err < ctl->hash_keysize; ++err)
> > > +		printk("%02x ", key[err]);
> > > +	printk("\n");
> > 
> > You don't want to print the key unconditional.
> 
> Debug prints are not supposed to be turned on except on very serious
> conditions. In this case we do need to have as much info as possible (like
> non-matching keys on different nodes for someone who cares).

Yeah, the dprintk()s are ok, but I was after the printk()s that follow. 
They are unconditional and will always print the key.

> > > +static struct crypto_ablkcipher *dst_init_cipher(struct dst_crypto_ctl *ctl, u8 *key)
> > > +{
> > > +	int err = -EINVAL;
> > 
> > Needless initialization. There are more in the code.
> > 
> > > +	struct crypto_ablkcipher *cipher;
> > > +
> > > +	if (!ctl->cipher_keysize)
> > > +		goto err_out_exit;
> 
> No, it is needed here.

Guess I picked a bad example... There are some in the code that are 
needless.

> > > +static int dst_crypt(struct dst_crypto_engine *e, struct bio *bio)
> > > +{
> > > +	struct ablkcipher_request *req = e->data;
> > > +
> > > +	memset(req, 0, sizeof(struct ablkcipher_request));
> > 
> > sizeof(*req) is preferred, likewise for other sizeof() uses in the code.
> 
> No, I do belive that grepping over |struct ablkcipher_request| when
> something is about to be changed is more convenient, than searching for
> the structure name and then object name itself.
> It is matter of a taste though.

Yeah, but in nearly all cases you don't need to change anything in that 
line, when you use sizeof(*ptr), because it always gets you the correct 
size you want. There are cases we could argue about, because you might 
want to do a limited memset() or memcpy() with a different size, but for 
most cases like memset() to zero or kmalloc, sizeof(*ptr) makes it clear 
that you want to clear out the whole structure or you want enough memory 
to store the type of ptr in it. Don't know how strict the policy is, but 
it's part of CodingStyle.

> > > +static int dst_create_node_attributes(struct dst_node *n)
> > > +{
> > > +	int err, i;
> > > +
> > > +	for (i=0; i<ARRAY_SIZE(dst_node_attrs); ++i)
> > > +		err = device_create_file(&n->device,
> > > +				&dst_node_attrs[i]);
> > 
> > If you really want to ignore the return value, use
> > 
> > (void) device_create_file(...)
> 
> I just want to shut up the compiler, since failing to register
> informational attribute is not critical. But it could also be
> used to fall the initialization.

For just shutting up the compiler, use the void cast. I think removing a 
failed attribute is ok.

> > > +	err = dst_commands[ctl->cmd](n, ctl, msg->data + sizeof(struct dst_ctl),
> > > +			msg->len - sizeof(struct dst_ctl));
> > > +
> > > +	dst_node_put(n);
> > > +out:
> > > +	ack = kmalloc(sizeof(struct dst_ctl_ack), GFP_KERNEL);
> > 
> > struct dst_ctl_ack seems to be quite small, guess there's no need for
> > dynamic allocation.
> 
> 36 bytes iirc - not that small for stack allocation I think.

In other cases you allocate u8 iv[32] on the stack, so I guess this point 
is void. And I think 36 bytes isn't that much and it looks like you're 
called from user space, so I don't think you have a deep callchain here.
