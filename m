Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbZGNCtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbZGNCtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 22:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZGNCtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 22:49:43 -0400
Received: from ozlabs.org ([203.10.76.45]:58484 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbZGNCtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 22:49:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Daniel Mierswa <impulze@impulze.org>
Subject: Re: [RFC] Re: Parsing kernel parameters and escaping "
Date: Tue, 14 Jul 2009 12:19:29 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4A50B09B.9030901@impulze.org> <200907130927.16203.rusty@rustcorp.com.au> <4A5AA0AD.2030502@impulze.org>
In-Reply-To: <4A5AA0AD.2030502@impulze.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907141219.30772.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 12:19:17 pm Daniel Mierswa wrote:
> Rusty Russell wrote:
> > It might be nice to have that test code somewhere at the bottom of
> > param.c, at least while we're playing with the code.
>
> Umm, I'm not sure where test-code is supposed to go in kernel code.
> Should it be a main() function, a test() function, just a comment, could
> you elaborate? All i did now was to build a small program that reads
> argv[1] and uses next_arg just like parse_args() in params.c does.

Usually I write a function like:

#if 0
static int param_result(char *param, char *val)
{
	static int expect;
	const char *params[] = { "foo", "foo", ... };
	const char *vals[] = "bar", NULL, ...};

	BUG_ON(strcmp(param,params[expect]) != 0);
	if (vals[expect] == NULL)
		BUGON(val);
	else
		BUGON(strcmp(val, vals[expect]) != 0);
}

static int test_params(void)
{
	char *str = kstrdup("foo=bar foo ...", GFP_KERNEL);
	parse_args("test", str, NULL, 0, param_result);
	return 0;
}
module_init(test_params);
#endif

> > Thanks!
>
> Ditto.

Thanks for all the work!
Rusty.
